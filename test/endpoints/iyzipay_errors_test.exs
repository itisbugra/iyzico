defmodule Iyzico.IyzipayErrorsTest do
  use Iyzico.EndpointCase
  doctest Iyzico.Iyzipay

  alias Iyzico.Address
  alias Iyzico.BasketItem
  alias Iyzico.Buyer
  alias Iyzico.Card
  alias Iyzico.PaymentRequest

  @current_locale Application.get_env(:iyzico, Iyzico)[:locale]

  setup do
    buyer =
      %Buyer{
        id: "BY789",
        name: "John",
        surname: "Doe",
        phone_number: "+905350000000",
        identity_number: "74300864791",
        email: "email@email.com",
        last_login_date: "2015-10-05 12:43:35",
        registration_date: "2013-04-21 15:12:09",
        registration_address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
        city: "Istanbul",
        country: "Turkey",
        zip_code: "34732",
        ip: "85.34.78.112"
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

    items = [
      %BasketItem{
        id: "BI101",
        name: "Binocular",
        category: "Collectibles",
        subcategory: "Accessories",
        type: :physical,
        price: "0.3"
      }, %BasketItem{
        id: "BI103",
        name: "USB",
        category: "Electronics",
        subcategory: "USB / Cable",
        type: :physical,
        price: "0.2"
      }
    ]
    
    %{buyer: buyer, shipping_address: shipping_address, billing_address: billing_address, items: items}
  end
  
  describe "erroneous cards" do
    test "insufficient funds", setup, do: assert gen_request(setup, "4111111111111129") == {:error, :insufficient_funds}
    test "do not honor", setup, do: assert gen_request(setup, "4129111111111111") == {:error, :do_not_honor}
    test "invalid transaction", setup, do: assert gen_request(setup, "4128111111111112") == {:error, :invalid}
    test "lost card", setup, do: assert gen_request(setup, "4127111111111113") == {:error, :stolen}
    test "stolen card", setup, do: assert gen_request(setup, "4126111111111114") == {:error, :stolen}
    test "expired card", setup, do: assert gen_request(setup, "4125111111111115") == {:error, :expired}
    test "invalid cvc", setup, do: assert gen_request(setup, "4124111111111116") == {:error, :invalid_cvc}
    test "not permitted to card holder", setup, do: assert gen_request(setup, "4123111111111117") == {:error, :holder_permit}
    test "not permitted to terminal", setup, do: assert gen_request(setup, "4122111111111118") == {:error, :terminal}
    test "fraud suspect", setup, do: assert gen_request(setup, "4121111111111119") == {:error, :fraud}
    test "pickup", setup, do: assert gen_request(setup, "4120111111111110") == {:error, :stolen}
    test "generic error", setup, do: assert gen_request(setup, "4130111111111118") == {:error, nil}
  end
  
  defp gen_request(setup, number) do
    card =
      %Card{
        holder_name: "John Doe",
        number: number,
        exp_month: 12,
        exp_year: 2030,
        cvc: 123
      }
    
    payment_request =
      %PaymentRequest{
        locale: @current_locale,
        conversation_id: "123456789",
        price: "0.5",
        paid_price: "0.7",
        currency: :try,
        basket_id: "B67832",
        payment_channel: :web,
        payment_group: :product,
        payment_card: card,
        installment: 1,
        buyer: setup.buyer,
        shipping_address: setup.shipping_address,
        billing_address: setup.billing_address,
        basket_items: setup.items
      }
      
    Iyzico.Iyzipay.process_payment_req(payment_request)
  end
end