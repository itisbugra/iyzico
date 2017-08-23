defmodule Iyzico.Payment do
  @moduledoc """
  Represents a successfully made payment returned from the platform.
  """

  @enforce_keys ~w(basket_id bin_id card_ref conversation_id currency
                   fraud_status installment transactions commission_fee commission_amount paid_price id
                   last_four_digits merchant_commission_rate merchant_commission_amount price)a

  defstruct [
    :basket_id,
    :bin_id,
    :card_ref,
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
  @type fraud_status :: :restrict | :awaiting | :ok

  @type t :: %__MODULE__{
    basket_id: binary,
    bin_id: binary,
    card_ref: Iyzico.CardReference.t,
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
