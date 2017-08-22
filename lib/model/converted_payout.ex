defmodule Iyzico.ConvertedPayout do
  @typedoc """
  Represents a converted payout of an item transaction.
  """

  @enforce_keys ~w(merchant_blockage_amount submerchant_blockage_amount currency
                   commission_fee commission_amount conversion_rate conversion_cost
                   merchant_payout_amount paid_price submerchant_payout_amount)a

  defstruct [
    :merchant_blockage_amount,
    :submerchant_blockage_amount,
    :currency,
    :commission_fee,
    :commission_amount,
    :conversion_rate,
    :conversion_cost,
    :merchant_payout_amount,
    :paid_price,
    :submerchant_payout_amount
  ]

  @type currency :: :try

  @type t :: %__MODULE__{
    merchant_blockage_amount: number,
    submerchant_blockage_amount: number,
    currency: currency,
    commission_fee: number,
    commission_amount: number,
    conversion_rate: number,
    conversion_cost: number,
    merchant_payout_amount: number,
    paid_price: number,
    submerchant_payout_amount: number
  }
end
