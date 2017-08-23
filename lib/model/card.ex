defmodule Iyzico.Card do
  @typedoc """
  Represents a card to perform the checkout.
  """
  import Iyzico.Client

  alias Iyzico.CardRegistrationRequest
  alias Iyzico.CardReference
  alias Iyzico.Metadata

  @enforce_keys ~w(holder_name number exp_year exp_month)a
  defstruct [
    :holder_name,
    :number,
    :exp_year,
    :exp_month,
    :cvc,
    :registration_alias,
  ]

  @type card_type :: :credit | :debit | :prepaid
  @type card_assoc :: :mastercard | :visa | :amex | :troy
  @type card_family :: :bonus | :axess | :world | :maximum | :paraf | :cardfinans | :advantage

  @type t :: %__MODULE__{
    holder_name: binary,
    number: binary,
    exp_year: integer,
    exp_month: integer,
    cvc: integer,
    registration_alias: binary
  }

  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  @doc """
  Stores a card with given external identifier. One can later retrieve or refer to the given card with that identifier.
  """
  @spec create_card(Iyzico.Card.t, binary, binary, binary) ::
    {:ok, Iyzico.CardReference.t, Iyzico.Metadata.t} |
    {:error, atom}
  def create_card(card = %Iyzico.Card{}, external_id, conversation_id, email) do
    registration =
      %CardRegistrationRequest{
        locale: @default_locale,
        conversation_id: conversation_id,
        external_id: external_id,
        email: email,
        card: card
      }

    case request([], :post, url_for_path("/cardstorage/card"), [], registration) do
      {:ok, resp} ->
        card_ref =
          %CardReference{
            user_key: resp["cardUserKey"],
            token: resp["cardToken"],
            alias: resp["cardAlias"],
            card: card,
            type: get_card_type(resp["cardType"]),
            assoc: get_card_assoc(resp["cardAssociation"]),
            family: get_card_family(resp["cardFamily"]),
            bank_name: resp["cardBankName"]
          }

        metadata =
          %Metadata{
            system_time: resp["systemTime"],
            succeed?: resp["status"] == "success",
            phase: nil,
            locale: resp["locale"],
            auth_code: nil
          }

        {:ok, card_ref, metadata}
      any ->
        any
    end
  end

  @doc """
  Invalidates a registration of given card.
  """
  @spec delete_card(Iyzico.Card.t) ::
    :ok |
    {:error, :not_found}
  def delete_card(card = %Iyzico.Card{}) do

  end

  @doc """
  Same as `delete_card/1` but raises `Iyzico.CardNotRegistered` error if card is not registered.
  """
  @spec delete_card!(Iyzico.Card.t) :: no_return
  def delete_card!(card = %Iyzico.Card{}) do

  end

  @doc """
  Retrieves all cards of a user.
  """
  @spec retrieve_cards() :: list
  def retrieve_cards() do

  end

  def valid?(card = %Iyzico.Card{}) do

  end

  defp validate_number(number) when is_binary(number) do
    Luhn.valid? number
  end

  defp validate_cvc(cvc) when is_integer(cvc) do
    cvc >= 100 and cvc < 1000
  end

  @doc """
  Converts a card association string into existing atom.

  ## Examples

      iex> Iyzico.Card.get_card_assoc "MASTER_CARD"
      :mastercard

      iex> Iyzico.Card.get_card_assoc "VISA"
      :visa

      iex> Iyzico.Card.get_card_assoc "AMERICAN_EXPRESS"
      :amex

      iex> Iyzico.Card.get_card_assoc "TROY"
      :troy
  """
  @spec get_card_assoc(String.t) :: card_assoc
  def get_card_assoc(assoc) do
    case assoc do
      "MASTER_CARD" ->
        :mastercard
      "VISA" ->
        :visa
      "AMERICAN_EXPRESS" ->
        :amex
      "TROY" ->
        :troy
    end
  end

  @doc """
  Converts a card type string into existing atom.

  ## Examples

      iex> Iyzico.Card.get_card_type "CREDIT_CARD"
      :credit

      iex> Iyzico.Card.get_card_type "DEBIT_CARD"
      :debit

      iex> Iyzico.Card.get_card_type "PREPAID_CARD"
      :prepaid
  """
  @spec get_card_type(String.t) :: card_type
  def get_card_type(type) do
    case type do
      "CREDIT_CARD" ->
        :credit
      "DEBIT_CARD" ->
        :debit
      "PREPAID_CARD" ->
        :prepaid
    end
  end

  @doc """
  Converts given card family string to existing atom.

  ## Examples

      iex> Iyzico.Card.get_card_family "Bonus"
      :bonus

      iex> Iyzico.Card.get_card_family "Axess"
      :axess

      iex> Iyzico.Card.get_card_family "World"
      :world

      iex> Iyzico.Card.get_card_family "Maximum"
      :maximum

      iex> Iyzico.Card.get_card_family "Paraf"
      :paraf

      iex> Iyzico.Card.get_card_family "CardFinans"
      :cardfinans

      iex> Iyzico.Card.get_card_family "Advantage"
      :advantage
  """
  @spec get_card_family(String.t) :: card_family
  def get_card_family(family) do
    case family do
      "Bonus" ->
        :bonus
      "Axess" ->
        :axess
      "World" ->
        :world
      "Maximum" ->
        :maximum
      "Paraf" ->
        :paraf
      "CardFinans" ->
        :cardfinans
      "Advantage" ->
        :advantage
    end
  end
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Card do
  def to_iolist(data) do
    ioelem =
      case data.registration_alias do
        nil ->
          {"registerCard", 0}
        _any ->
          {"registerCard", 1}
      end

    [{"cardHolderName", data.holder_name},
     {"cardNumber", data.number},
     {"expireYear", data.exp_year},
     {"expireMonth", data.exp_month},
     {"cvc", data.cvc},
     ioelem]
  end
end
