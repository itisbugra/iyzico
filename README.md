# iyzico Elixir Client

A minimal *iyzico* client.

[![Build Status](https://travis-ci.org/Chatatata/iyzico.svg?branch=master)](https://travis-ci.org/Chatatata/iyzico)
[![Hex.pm](https://img.shields.io/hexpm/v/iyzico.svg)](https://hex.pm/packages/iyzico)
[![Hexdocs.pm](https://img.shields.io/badge/hexdocs-available-a5439a.svg)](https://hexdocs.pm/iyzico/)
[![Downloads](https://img.shields.io/hexpm/dt/iyzico.svg)](https://hex.pm/packages/iyzico)
[![Inline docs](http://inch-ci.org/github/Chatatata/iyzico.svg)](http://inch-ci.org/github/Chatatata/iyzico)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/Chatatata/iyzico.svg)](https://beta.hexfaktor.org/github/Chatatata/iyzico)

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
  server_ip: {67, 43, 43, 43}
```

## Contribution

All contributions are welcomed as long as you follow the conventions of *Elixir* language.

## License

MIT
