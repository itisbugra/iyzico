defmodule Iyzico.Payment do
  @moduledoc """
  Represents a successfully made payment returned from the platform.
  """

  @enforce_keys ~w(basket_id bin_id card_assoc card_family card_type conversation_id currency
                   fraud_status installment transactions commission_fee commission_amount paid_price id
                   last_four_digits merchant_commission_rate merchant_commission_amount price)a

  defstruct [
    :basket_id,
    :bin_id,
    :card_assoc,
    :card_family,
    :card_type,
    :conversation_id,
    :currency,
    :fraud_status,
    :installment,
    :transactions,
    :commission_fee,
    :commission_amount,
    :paid_price,
    :id,
    :last_four_digits,
    :merchant_commission_rate,
    :merchant_commission_amount,
    :price
  ]

  @type currency :: :try
  @type card_type :: :credit | :debit | :prepaid
  @type card_assoc :: :mastercard | :visa | :amex | :troy
  @type card_family :: :bonus | :axess | :world | :maximum | :paraf | :cardfinans | :advantage
  @type fraud_status :: :restrict | :awaiting | :ok

  @type t :: %__MODULE__{
    basket_id: binary,
    bin_id: binary,
    card_assoc: card_assoc,
    card_family: card_family,
    card_type: card_type,
    conversation_id: binary,
    currency: currency,
    fraud_status: fraud_status,
    installment: integer,
    transactions: list,
    commission_fee: number,
    commission_amount: number,
    last_four_digits: binary,
    merchant_commission_rate: number,
    merchant_commission_amount: number,
    paid_price: number,
    price: number,
    id: binary
  }

  @doc """
  Converts a card association string into existing atom.

  ## Examples

      iex> Iyzico.Payment.get_card_assoc "MASTER_CARD"
      :mastercard

      iex> Iyzico.Payment.get_card_assoc "VISA"
      :visa

      iex> Iyzico.Payment.get_card_assoc "AMERICAN_EXPRESS"
      :amex

      iex> Iyzico.Payment.get_card_assoc "TROY"
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

      iex> Iyzico.Payment.get_card_type "CREDIT_CARD"
      :credit

      iex> Iyzico.Payment.get_card_type "DEBIT_CARD"
      :debit

      iex> Iyzico.Payment.get_card_type "PREPAID_CARD"
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

      iex> Iyzico.Payment.get_card_family "Bonus"
      :bonus

      iex> Iyzico.Payment.get_card_family "Axess"
      :axess

      iex> Iyzico.Payment.get_card_family "World"
      :world

      iex> Iyzico.Payment.get_card_family "Maximum"
      :maximum

      iex> Iyzico.Payment.get_card_family "Paraf"
      :paraf

      iex> Iyzico.Payment.get_card_family "CardFinans"
      :cardfinans

      iex> Iyzico.Payment.get_card_family "Advantage"
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

  @doc """
  Converts a given integer representation of a fraud status of a payment to respective type.

  ## Discussion

  A merchant should only proceed to the transaction if and only if the fraud status is `:ok`.
  A payments fraud status would be `:awaiting` if transaction safety is being processed in present.
  Transactions with fraud status with `:restrict` value should be avoided.

  ## Examples

      iex> Iyzico.Payment.to_fraud_status -1
      :restrict

      iex> Iyzico.Payment.to_fraud_status 0
      :awaiting

      iex> Iyzico.Payment.to_fraud_status 1
      :ok
  """
  @spec to_fraud_status(integer) :: fraud_status
  def to_fraud_status(status) do
    case status do
      -1 ->
        :restrict
      0 ->
        :awaiting
      1 ->
        :ok
    end
  end
end
