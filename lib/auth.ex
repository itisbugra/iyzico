defmodule Iyzico.Auth do
  @doc false

  import Iyzico.CompileTime

  @auth_header "Authorization"
  @random_header "x-iyzi-rnd"
  @client_version_header "x-iyzi-client-version"
  @auth_header_prefix "IYZWS"
  @client_title "iyzico Elixir Client"
  @client_version Mix.Project.config()[:version]
  @rand_string_size 13
  @api_key Application.get_env(:iyzico, Iyzico)[:api_key]
  @api_secret Application.get_env(:iyzico, Iyzico)[:api_secret]

  static_assert_binary(@api_key, message: "API key should exist.")
  static_assert_binary(@api_secret, message: "API secret should exist.")

  def gen_headers(serialized_body) do
    api_key = Application.get_env(:iyzico, Iyzico)[:api_key]
    api_secret = Application.get_env(:iyzico, Iyzico)[:api_secret]
    rand_string = gen_rand_string(@rand_string_size)

    [gen_auth_header(rand_string, api_key, api_secret, serialized_body),
     gen_rand_string_header(rand_string),
     gen_version_header()]
  end

  defp gen_auth_header(rand_string, api_key, api_secret, serialized_body) do
    digest =
      rand_string
      |> gen_digest(api_key, api_secret, serialized_body)
      |> Base.encode64()

    auth_header = @auth_header_prefix <> " " <> api_key <> ":" <> digest

    #  TODO: Write a function to convert string to charlist tuple
    {String.to_charlist(@auth_header), String.to_charlist(auth_header)}
  end

  defp gen_rand_string_header(rand_string) do
    {String.to_charlist(@random_header), String.to_charlist(rand_string)}
  end

  defp gen_version_header() do
    {String.to_charlist(@client_version_header), String.to_charlist(@client_title <> " - " <> @client_version)}
  end

  defp gen_digest(rand_string, api_key, api_secret, serialized_body) do
    substrate = api_key <> rand_string <> api_secret <> serialized_body

    :crypto.hash(:sha, substrate)
  end

  # ref: https://stackoverflow.com/questions/32001606/how-to-generate-a-random-url-safe-string-with-elixir
  defp gen_rand_string(length), do: :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
end
