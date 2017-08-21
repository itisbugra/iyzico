defmodule Iyzico.Payment do
  @moduledoc """
  Represents a successfully made payment returned from the platform.
  """

  @enforce_keys ~w(basket_id bin_id card_association card_family card_type conversation_id currency
                   fraud_status installment transactions commission_fee commission_rate paid_price payment_id
                   last_four_digits merchant_commission_rate merchant_commission_amount)a
end
