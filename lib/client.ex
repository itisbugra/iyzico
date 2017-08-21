defmodule Iyzico.Client do
  @moduledoc """
  Provides functions for using remote API.
  """
  import Iyzico.Auth
  import Iyzico.Serialization

  alias Iyzico.PaymentRequest

  @base_url Application.get_env(:iyzico, Iyzico)[:base_url]

  def test_remote_host() do
    case request([], :get, url_for_path("/payment/test"), [], nil) do
      {:ok, resp} ->
        {:ok, resp["systemTime"]}
      _ ->
        {:error, :eunkresp}
    end
  end

  def test_remote_host!() do
    case test_remote_host() do
      {:ok, time} ->
        time
      {} ->
        raise Iyzico.UnexpectedResponseError
    end
  end

  def url_for_path(path), do: @base_url <> path

  def request(conf, method, url, headers, body) when is_atom(method) and is_binary(url) do
    url = String.to_char_list(url)
    opts = conf[:httpc_opts] || []
    serialized_body = serialize(body)
    IO.inspect serialized_body
    headers = headers ++ gen_headers(serialized_body)

    case method do
      :get ->
        :httpc.request(:get, {url, headers}, opts, body_format: :binary)
      _ ->
        headers = headers ++ [{'Content-Type', 'application/json'}]
        :httpc.request(method, {url, headers, 'application/json', Poison.encode!(body)}, opts, body_format: :binary)
    end
    |> normalize_response
  end

  defp normalize_response(response) do
    case response do
      {:ok, {{_httpvs, 200, _status_phrase}, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, 200, _status_phrase}, _headers, json_body}} ->
        {:ok, Poison.decode!(json_body)}
      {:ok, {{_httpvs, status, _status_phrase}, json_body}} ->
        {:error, status, Poison.decode!(json_body)}
      {:ok, {{_httpvs, status, _status_phrase}, _headers, json_body}} ->
        {:error, status, Poison.decode!(json_body)}
      {:error, reason} -> {:error, :bad_fetch, reason}
    end
  end
end
