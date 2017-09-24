defmodule Iyzico.Card do
  @moduledoc """
  A module representing cards used in monetary transactions.
  """

  @enforce_keys ~w(holder_name number exp_year exp_month)a

  defstruct [
    :holder_name,
    :number,
    :exp_year,
    :exp_month,
    :cvc,
    :registration_alias,
  ]

  @typedoc """
  Represents type of a card.

  ##  Card types

  - `:credit`: A credit card performs a transaction by borrowing money made available to a individual, who is a customer
  of a financial institution. The transferred funds are payed as a debt from the supplier bank to the vendor, which is
  ultimately paid by the credit card user.

  - `:debit`: A debit card performs a transaction by directly withdrawing the funds from its coupled bank account.

  - `:prepaid`: A reloadable card which performs a transaction by using pre-deposited funds.

  *Reference: [YoungMoney](http://finance.youngmoney.com/credit_debt/credit_basics/credit_debit_prepaid/).*
  """
  @type card_type :: :credit | :debit | :prepaid

  @typedoc """
  Represents supplier association of a card.

  ## Caveats

  `:troy` is a Turkish supplier and only available in Turkey.
  """
  @type card_assoc :: :mastercard | :visa | :amex | :troy

  @typedoc """
  Represents family of a card.
  """
  @type card_family :: :bonus | :axess | :world | :maximum | :paraf | :cardfinans | :advantage | :neo | :denizbank | :cardfinans | :halkbank | :is_bank | :vakifbank | :yapi_kredi

  @typedoc """
  Represents a card to perform the checkout.

  ## Fields

  - `:holder_name`: Name of the holder of the card.
  - `:number`: Number of the card.
  - `:exp_year`: Latest two digits of expiration year of the card, *(e.g.: 21 for 2021)*.
  - `:exp_month`: Index of the expiration month starting form 1, *(e.g.: 1 for January)*.
  - `:cvc`: CVC or CVV number of the card, typically three to four digits.
  - `:registration_alias`: Alias of the card if it needs to be registered with ongoing transaction, optional.
  """
  @type t :: %__MODULE__{
    holder_name: binary,
    number: binary,
    exp_year: integer,
    exp_month: integer,
    cvc: integer,
    registration_alias: binary
  }

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

      iex> Iyzico.Card.get_card_family "Neo"
      :neo

      iex> Iyzico.Card.get_card_family "Denizbank DC"
      :denizbank

      iex> Iyzico.Card.get_card_family "Cardfinans DC"
      :cardfinans

      iex> Iyzico.Card.get_card_family "Halkbank DC"
      :halkbank

      iex> Iyzico.Card.get_card_family "Bankamatik"
      :is_bank

      iex> Iyzico.Card.get_card_family "Vakıfbank DC"
      :vakifbank

      iex> Iyzico.Card.get_card_family "Tlcard"
      :yapi_kredi
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
      "Neo" ->
        :neo
      "Denizbank DC" ->
        :denizbank
      "Cardfinans DC" ->
        :cardfinans
      "Halkbank DC" ->
        :halkbank
      "Bankamatik" ->
        :is_bank
      "Vakıfbank DC" ->
        :vakifbank
      "Tlcard" ->
        :yapi_kredi
    end
  end
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Card do
  def to_iolist(data) do
    case data.registration_alias do
      nil ->
        [{"cardHolderName", data.holder_name},
         {"cardNumber", data.number},
         {"expireYear", data.exp_year},
         {"expireMonth", data.exp_month},
         {"cvc", data.cvc},
         {"registerCard", 0}]
      _any ->
        [{"cardAlias", data.registration_alias},
         {"cardNumber", data.number},
         {"expireYear", data.exp_year},
         {"expireMonth", data.exp_month},
         {"cardHolderName", data.holder_name}]
    end
  end
end
