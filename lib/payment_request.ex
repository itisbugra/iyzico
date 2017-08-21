defmodule Iyzico.PaymentRequest do
  @moduledoc """
  Represents a payment request information.
  """
  @enforce_keys ~w(conversation_id price
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
    :payment_card,
    :buyer,
    :shipping_address,
    :billing_address,
    :basket_items
  ]

  @type currency :: :try
  @type payment_channel :: :web
  @type payment_group :: :product

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
    payment_card: Iyzico.Card.t,
    buyer: Iyzico.Buyer.t,
    shipping_address: Iyzico.Address.t,
    billing_address: Iyzico.Address.t,
    basket_items: list
  }

  import Iyzico.Client

  def retrieve_installment() do

  end

  def retrieve_bin(bin) do

  end

  def fetch_payment_result() do

  end

  defp validate_struct(request = %Iyzico.PaymentRequest{}) do
    result =
      Enum.reduce(Map.keys(request), fn(key, acc) ->
        acc and (not is_nil(Map.fetch(request, key)))
      end)

    Map.put(request, :valid?, result)
  end

  defmodule View do
    @default_locale Application.get_env(:iyzico, Iyzico)[:locale]

    def render_iolist(payment_request = %Iyzico.PaymentRequest{}) do
      [{"locale", @default_locale},
       {"conversationId", payment_request.conversation_id},
       {"price", payment_request.price},
       {"paidPrice", payment_request.paid_price},
       {"installment", payment_request.installment},
       {"paymentChannel", Atom.to_string(payment_request.payment_channel) |> String.upcase()},
       {"paymentGroup", Atom.to_string(payment_request.payment_group) |> String.upcase()},
       {"basketId", payment_request.basket_id},
       {"paymentCard", Iyzico.Card.View.render_iolist(payment_request.payment_card)},
       {"buyer", Iyzico.Buyer.View.render_iolist(payment_request.buyer)},
       {"shippingAddress", Iyzico.Address.View.render_iolist(payment_request.shipping_address)},
       {"billingAddress", Iyzico.Address.View.render_iolist(payment_request.billing_address)},
       {"basketItems", Enum.map(payment_request.basket_items, &Iyzico.BasketItem.View.render_iolist/1)},
       {"currency", Atom.to_string(payment_request.currency) |> String.upcase()}]
    end
  end
end
