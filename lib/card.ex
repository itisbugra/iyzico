defmodule Iyzico.Card do
  @moduledoc """
  Represents a card to perform the checkout.
  """

  @enforce_keys ~w(holder_name number exp_year exp_month cvc)a
  defstruct [
    :holder_name,
    :number,
    :exp_year,
    :exp_month,
    :cvc
  ]

  @type t :: %__MODULE__{
    holder_name: binary,
    number: binary,
    exp_year: integer,
    exp_month: integer,
    cvc: integer
  }

  def create_card(card = %Iyzico.Card{}) do

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

  defp validate_struct(card = %Iyzico.Card{}) do
    result =
      Enum.reduce(Map.keys(card), fn(key, acc) ->
        not is_nil(Map.fetch(card, key))
      end)

    Map.put(card, :valid?, result)
  end

  defp validate_number(number) when is_binary(number) do
    Luhn.valid? number
  end

  defp validate_cvc(cvc) when is_integer(cvc) do
    cvc >= 100 and cvc < 1000
  end

  defmodule View do
    def render_iolist(card = %Iyzico.Card{}) do
      [{"cardHolder", card.holder_name},
       {"cardNumber", card.number},
       {"expireYear", card.exp_year},
       {"expireMonth", card.exp_month},
       {"cvc", card.cvc}]
    end
  end
end
