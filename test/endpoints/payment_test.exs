defmodule IyzicoTest do
  use Iyzico.EndpointCase
  doctest Iyzico

  import Iyzico.Client

  alias Iyzico.Address
  alias Iyzico.BasketItem
  alias Iyzico.Buyer
  alias Iyzico.Card
  alias Iyzico.PaymentRequest

  @current_locale Application.get_env(:iyzico, Iyzico)[:locale]

  test "completes endpoint test" do
    result = test_remote_host()

    assert is_tuple(result)
    assert elem(result, 0) == :ok
    assert is_integer(elem(result, 1))
  end

  test "completes a checkout" do
    card =
      %Card{
        holder_name: "John Doe",
        number: "5528790000000008",
        exp_month: 12,
        exp_year: 2030,
        cvc: 123
      }

    buyer =
      %Buyer{
        id: "BY789",
        name: "John",
        surname: "Doe",
        phone_number: "+905350000000",
        identity_number: "1111111111111",
        email: "mail@exchange.com",
        last_login_date: "2015-10-05 12:43:35",
        registration_date: "2013-04-21 15:12:09",
        registration_address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
        city: "Istanbul",
        country: "Turkey",
        zip_code: "34732",
        ip: {85, 34, 78, 112}
      }

    shipping_address =
      %Address{
        address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
        zip_code: "34742",
        contact_name: "Jane Doe",
        city: "Istanbul",
        country: "Turkey"
      }

    billing_address =
      %Address{
        address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
        zip_code: "34742",
        contact_name: "Jane Doe",
        city: "Istanbul",
        country: "Turkey"
      }

    binocular_item =
      %BasketItem{
        id: "BI101",
        name: "Binocular",
        category: "Collectibles",
        subcategory: "Accessories",
        type: :physical,
        price: "0.3"
      }

    payment_request =
      %PaymentRequest{
        locale: @current_locale,
        conversation_id: "123456789",
        price: "1.0",
        paid_price: "1.1",
        currency: :try,
        basket_id: "B67832",
        payment_channel: :web,
        payment_group: :product,
        payment_card: card,
        installment: 1,
        buyer: buyer,
        shipping_address: shipping_address,
        billing_address: billing_address,
        basket_items: [
          binocular_item
        ]
      }

    IO.inspect Iyzico.Iyzipay.process_payment_req!(payment_request)
  end
end
