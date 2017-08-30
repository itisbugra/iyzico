defmodule Iyzico.Client do
  @moduledoc false
  import Iyzico.Auth
  import Iyzico.Serialization

  import Iyzico.CompileTime

  @base_url Application.get_env(:iyzico, Iyzico)[:base_url]

  static_assert_binary(@base_url)

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

  def request(conf, method, url, headers, body, opts \\ []) when is_atom(method) and is_binary(url) do
    url = String.to_charlist(url)
    httpc_opts = conf[:httpc_opts] || []

    case method do
      :get ->
        headers = headers ++ gen_headers("", opts)
        :httpc.request(:get, {url, headers}, httpc_opts, body_format: :binary)
      _ ->
        serialized_body = serialize(Iyzico.IOListConvertible.to_iolist(body))
        json_body = to_json(Iyzico.IOListConvertible.to_iolist(body))

<<<<<<< HEAD
        IO.inspect serialized_body
        IO.inspect json_body

        headers = headers ++ gen_headers(serialized_body) ++ [{'Content-Type', 'application/json'}]
        :httpc.request(method, {url, headers, 'application/json', json_body}, opts, body_format: :binary)
=======
        headers = headers ++ gen_headers(serialized_body, opts) ++ [{'Content-Type', 'application/json'}]
        :httpc.request(method, {url, headers, 'application/json', json_body}, httpc_opts, body_format: :binary)
>>>>>>> 0835d06f8e842feaa93032e99076a1ead26a48d8
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
