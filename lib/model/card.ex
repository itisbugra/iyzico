defmodule Iyzico.Card do
  @typedoc """
  Represents a card to perform the checkout.
  """

  @enforce_keys ~w(holder_name number exp_year exp_month cvc)a
  defstruct [
    :holder_name,
    :number,
    :exp_year,
    :exp_month,
    :cvc,
    :register?
  ]

  @type t :: %__MODULE__{
    holder_name: binary,
    number: binary,
    exp_year: integer,
    exp_month: integer,
    cvc: integer,
    register?: integer
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

  def valid?(card = %Iyzico.Card{}) do

  end

  defp validate_number(number) when is_binary(number) do
    Luhn.valid? number
  end

  defp validate_cvc(cvc) when is_integer(cvc) do
    cvc >= 100 and cvc < 1000
  end
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Card do
  def to_iolist(data) do
    [{"cardHolderName", data.holder_name},
     {"cardNumber", data.number},
     {"expireYear", data.exp_year},
     {"expireMonth", data.exp_month},
     {"cvc", data.cvc},
     {"registerCard", data.register?}]
  end
end
