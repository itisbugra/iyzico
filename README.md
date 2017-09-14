# iyzico Elixir Client

A minimal *iyzico* client.

###### Currently maintained by @heybuybuddy.


[![Build Status](https://travis-ci.org/Chatatata/iyzico.svg?branch=master)](https://travis-ci.org/Chatatata/iyzico)

## Installation

[Available in Hex](https://hex.pm/packages/iyzico), the package can be installed
by adding `iyzico` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:iyzico, "~> 1.0"}]
end
```

## Documentation

[Available in HexDocs](https://hexdocs.pm/iyzico/). You can also [download](https://repo.hex.pm/docs/iyzico-1.3.0.tar.gz) it to use it offline.

We try hard to make available documentation for all features. Please be calm while we documenting new features.

## Configuration

You may get your own *API key* and *API secret* from (https://sandbox-merchant.iyzipay.com).
Once you're ready to production, you will ultimately need to use production mode.
This is achieved by providing `:prod` parameter to `:world` key.

```elixir
config :iyzico, Iyzico,
  locale: "en",
  api_key: "sandbox-qO7nc7SfZobKsgQq81r518pEnfg6FJQE",
  api_secret: "sandbox-OFVrJ1h8QM8xq8BMTKBiZUa92JcD2B8g",
  world: :sandbox,
  base_url: "https://sandbox-api.iyzipay.com"
```

## Usage

#### Making a payment
```elixir
alias Iyzico.Iyzipay

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

binocular_item =
  %BasketItem{
    id: "BI101",
    name: "Binocular",
    category: "Collectibles",
    subcategory: "Accessories",
    type: :physical,
    price: "0.3"
  }

game_item =
  %BasketItem{
    id: "BI103",
    name: "USB",
    category: "Electronics",
    subcategory: "USB / Cable",
    type: :physical,
    price: "0.2"
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
    buyer: buyer,
    shipping_address: shipping_address,
    billing_address: billing_address,
    basket_items: [
      binocular_item,
      game_item
    ]
  }

payment = Iyzipay.process_payment_req!(payment_request)
```

#### Registering a card to the platform
```elixir
alias Iyzico.CardRegistration

card =
  %Card{
    holder_name: "Buğra Ekuklu",
    number: "5528790000000008",
    exp_year: 19,
    exp_month: 08,
    cvc: 543,
    registration_alias: "Buğra's credit card"
  }

registration = CardRegistration.create_card!(card, "external_id", "conversation_id", "test@mail.com")
```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT
