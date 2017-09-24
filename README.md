# iyzico Elixir Client

A minimal *iyzico* client.

###### Currently maintained by [@heybuybuddy](https://github.com/heybuybuddy/).

[![Build Status](https://travis-ci.org/Chatatata/iyzico.svg?branch=master)](https://travis-ci.org/Chatatata/iyzico)
[![Inline docs](http://inch-ci.org/github/Chatatata/iyzico.svg)](http://inch-ci.org/github/Chatatata/iyzico)

## Installation

[Available in Hex](https://hex.pm/packages/iyzico), the package can be installed
by adding `iyzico` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:iyzico, "~> 1.0"}]
end
```

## Documentation

[Available in HexDocs](https://hexdocs.pm/iyzico/).
You can also [download](https://repo.hex.pm/docs/iyzico-1.3.0.tar.gz) it to use it offline.

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
  base_url: "https://sandbox-api.iyzipay.com",
  ip: {67, 43, 43, 43}
```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT
