defmodule Iyzico.Transaction do
  @typedoc """
  Represents a single unit transaction of a payment.
  """

  # TODO: Should convert binary string formatted date to native naive datetime.

  @enforce_keys ~w(blockage_rate merchant_blockage_amount submerchant_blockage_amount
                   resolution_date converted_payout item_id commission_fee
                   commission_amount merchant_commission_rate merchant_commission_amount
                   paid_price id merchant_payout_amount price submerchant_payout_amount
                   submerchant_payout_rate submerchant_price transaction_status)a

  defstruct [
    :blockage_rate,
    :merchant_blockage_amount,
    :resolution_date,
    :submerchant_blockage_amount,
    :converted_payout,
    :item_id,
    :commission_fee,
    :commission_amount,
    :merchant_commission_rate,
    :merchant_commission_amount,
    :paid_price,
    :id,
    :price,
    :merchant_payout_amount,
    :submerchant_payout_amount,
    :submerchant_payout_rate,
    :submerchant_price,
    :transaction_status
  ]

  @type transaction_status :: :rejected | :on_hold | :on_market | :ok

  @type t :: %__MODULE__{
    blockage_rate: number,
    merchant_blockage_amount: number,
    submerchant_blockage_amount: number,
    resolution_date: binary,
    converted_payout: Iyzico.ConvertedPayout.t,
    item_id: binary,
    commission_fee: number,
    commission_amount: number,
    merchant_commission_rate: number,
    merchant_commission_amount: number,
    paid_price: number,
    price: number,
    id: binary,
    merchant_payout_amount: number,
    submerchant_payout_amount: number,
    submerchant_payout_rate: number,
    submerchant_price: number,
    transaction_status: transaction_status
  }

  @doc """
  Converts an integer constant to corresponding transaction status as an atom.

    iex> to_transaction_status(-1)
    :rejected

    iex> to_transaction_status(0)
    :on_hold

    iex> to_transaction_status(1)
    :on_market

    iex> to_transaction_status(2)
    :ok
  """
  @spec to_transaction_status(integer) :: transaction_status
  def to_transaction_status(status) do
    case status do
      -1 ->
        :rejected
      0 ->
        :on_hold
      1 ->
        :on_market
      2 ->
        :ok
    end
  end
end
