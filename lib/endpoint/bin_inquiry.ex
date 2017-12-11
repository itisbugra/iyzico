defmodule Iyzico.Inquiry do
  @moduledoc false
  @doc false

  defstruct [ :bin, :conversation_id, :price, :currency ]

  @type currency :: :try

  @type t :: %__MODULE__{
    bin: binary,
    conversation_id: binary,
    price: number,
    currency: currency
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Inquiry do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"binNumber", data.bin},
     {"price", data.price},
     {"currency", Atom.to_string(data.currency) |> String.upcase()}]
  end
end

defmodule Iyzico.BinInquiry do
  @bin_length 6
  @moduledoc """
  Functions for inquirying cards from their BIN numbers to fetch superficial information.

  ## Motivation

  Before requesting to confirm a payment,
    - users could be interrogated with available installment options, or
    - one might need to show card family as an overlay in the user interface of an application, or
    - user interface might show a switch for *3D Secure* preference of a user.

  Emanating from those philosophical concerns, a superficial information could be fetched upon given BIN number, which
  is first #{@bin_length} characters of a credit card number.

  ## Performing inquiry

  You can retrieve card information with providing a BIN number:

  ```
  {:ok, inquiry, metadata} = perform_inquiry("450634", "123456789", "100.00")
  ```

  If you already have a card, you can also supply it to the same function:

  ```
  card = %Iyzico.Card{}

  {:ok, inquiry, metadata} = perform_inquiry(card, "123456789", "100.00")
  ```

  ## Common options

  - `:api_key`: API key to be used in authentication, optional. Configuration is used instead if not supplied.

  - `:api_secret`: API secret key to be used in authentication. Configuration is used instead if not supplied.
  """

  @type currency :: :try | :eur

  import Iyzico.Client
  import Iyzico.Card
  import Iyzico.ErrorHandler

  alias Iyzico.InquiryResult
  alias Iyzico.Metadata
  alias Iyzico.CardReference
  alias Iyzico.InstallmentOption

  @doc """
  Inquiries given BIN number/card with price, retrieves details and specifications for the given card,
  available installment options and shows whether usage of *3D Secure* is mandatory.

  ## Caveats

  - If the card appears to be a `:debit` card, *3D Secure* is mandatory.
  - The underlying inquiry response represents a subset of the values found in *Installment & Commission Management*
  panel.
  - Local cards could not perform transactions in foreign currencies.

  ## Options

  See common options.
  """
  @spec perform_inquiry(Iyzico.Card.t | binary, binary, binary, currency, Keyword.t) ::
    {:ok, Iyzico.Inquiry.t, Iyzico.Metadata.t} |
    {:error, atom}
  def perform_inquiry(bin_or_card, conversation_id, price, currency, opts \\ [])
  def perform_inquiry(card = %Iyzico.Card{}, conversation_id, price, currency, opts)
    when is_binary(conversation_id) and is_binary(price) do
    inquiry =
      %Iyzico.Inquiry{
        conversation_id: conversation_id,
        bin: String.slice(card.number, 0..@bin_length),
        price: price,
        currency: currency
      }

    case request([], :post, url_for_path("/payment/iyzipos/installment"), [], inquiry, opts) do
      {:ok, resp} ->
        if resp["status"] == "success",
          do: serialize_resp(resp),
        else: handle_error(resp)
      any ->
        any
    end
  end
  def perform_inquiry(bin, conversation_id, price, currency, opts)
    when is_binary(bin) and is_binary(conversation_id) and is_binary(price) do
    if String.length(bin) == @bin_length do
      inquiry =
        %Iyzico.Inquiry{
          conversation_id: conversation_id,
          bin: bin,
          price: price,
          currency: currency
        }

      case request([], :post, url_for_path("/payment/iyzipos/installment"), [], inquiry, opts) do
        {:ok, resp} ->
          if resp["status"] == "success",
            do: serialize_resp(resp),
          else: handle_error(resp)
        any ->
          any
      end
    else
      {:error, :einval}
    end
  end

  defp serialize_resp(resp) do
    details = List.first(resp["installmentDetails"])

    result =
      %InquiryResult{
        card_ref: %CardReference{
          assoc: get_card_assoc(details["cardAssociation"]),
          family: get_card_family(details["cardFamilyName"]),
          type: get_card_type(details["cardType"]),
          bank_name: details["bankName"]
        },
        price: details["price"],
        installment_opts: Enum.map(details["installmentPrices"], fn (x) ->
          %InstallmentOption{
            per_month_price: x["installmentPrice"],
            stages: x["installmentNumber"]
          }
        end),
        is_secure_payment_mandatory?: details["forceCvc"] == 1
      }

    metadata =
      %Metadata{
        system_time: resp["systemTime"],
        succeed?: resp["status"] == "success",
        phase: resp["phase"],
        locale: resp["locale"],
        auth_code: resp["authCode"]}

    {:ok, result, metadata}
  end
end
