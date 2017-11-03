defmodule Iyzico.SecurePaymentRequest do
  @moduledoc """
  Data structures and functions involving secure payments.
  """
  @enforce_keys ~w(conversation_id price
                   paid_price currency installment
                   basket_id payment_channel
                   payment_group payment_card
                   callback_url)a

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
    :payment_card,
    :buyer,
    :shipping_address,
    :billing_address,
    :basket_items,
    :callback_url
  ]

  @typedoc """
  Represents currency of the candidate payment.
  """
  @type currency :: :try

  @typedoc """
  Represents channel of the candidate payment.
  """
  @type payment_channel :: :web

  @typedoc """
  Represents group of the candidate payment.
  """
  @type payment_group :: :product

  @typedoc """
  Represents a secure payment request.

  The only difference of this struct from `Iyzico.PaymentRequest.t` struct is `callback_url` field.
  """
  @type t :: %__MODULE__{
    locale: binary,
    conversation_id: binary,
    price: binary,
    paid_price: binary,
    currency: currency,
    installment: integer,
    basket_id: binary,
    payment_channel: payment_channel,
    payment_group: payment_group,
    payment_card: Iyzico.Card.t | Iyzico.RegisteredCard.t,
    buyer: Iyzico.Buyer.t,
    shipping_address: Iyzico.Address.t,
    billing_address: Iyzico.Address.t,
    basket_items: list,
    callback_url: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.SecurePaymentRequest do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"price", data.price},
     {"paidPrice", data.paid_price},
     {"installment", data.installment},
     {"paymentChannel", Atom.to_string(data.payment_channel) |> String.upcase()},
     {"basketId", data.basket_id},
     {"paymentGroup", Atom.to_string(data.payment_group) |> String.upcase()},
     {"paymentCard", Iyzico.IOListConvertible.to_iolist(data.payment_card)},
     {"buyer", Iyzico.IOListConvertible.to_iolist(data.buyer)},
     {"shippingAddress", Iyzico.IOListConvertible.to_iolist(data.shipping_address)},
     {"billingAddress", Iyzico.IOListConvertible.to_iolist(data.billing_address)},
     {"basketItems", Enum.map_reduce(data.basket_items, 0, fn (x, acc) ->
       {{acc, Iyzico.IOListConvertible.to_iolist(x)}, acc + 1}
     end) |> elem(0)},
     {"currency", Atom.to_string(data.currency) |> String.upcase()},
     {"callbackUrl", data.callback_url}]
  end
end
