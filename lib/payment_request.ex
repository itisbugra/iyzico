defmodule Iyzico.PaymentRequest do
  @moduledoc """
  Represents a payment request information.
  """
  @enforce_keys ~w(locale conversation_id price
                   paid_price currency installment
                   basket_id payment_channel
                   payment_group payment_card)a
  defstruct [
    :locale,
    :conversation_id,
    :price,
    :paid_price,
    :currency,
    :installment,
    :basket_id,
    :payment_channel,
    :payment_group,
    :payment_card
  ]

  @type t :: %__MODULE__{
    locale: binary,
    conversation_id: binary,
    price: binary,
    paid_price: binary,
    currency: binary,
    installment: integer,
    basket_id: binary,
    payment_channel: atom,
    payment_group: atom
  }
end
