defmodule Iyzico.Client do

  alias Iyzico.PaymentRequest

  @doc """
  Processes the given payment request on the remote API.
  """
  def process_payment_req(payment = %PaymentRequest{}) do
    
  end

  @doc """
  Same as `process_payment_req/1`, but raises an `Iyzico.PaymentProcessingError` exception in case of failure.
  Otherwise returns successfully processed payment.
  """
  def process_payment_req!(payment = %PaymentRequest{}) do
    case process_payment_req(payment) do
      {:ok, payment} ->
        payment
      {:error, code} ->
        raise Iyzico.PaymentProcessingError, code: code
    end
  end

  defp request(conf, method, url, headers, body) do
    url  = String.to_char_list(url)
    opts = conf[:httpc_opts] || []

    case method do
      :get ->
        headers = headers ++ [auth_header()]
        :httpc.request(:get, {url, headers}, opts, body_format: :binary)
      _ ->
        headers = headers ++ [auth_header(), {'Content-Type', 'application/json'}]
        :httpc.request(method, {url, headers, ctype, body}, opts, body_format: :binary)
    end
    |> normalize_response
  end

  defp get_auth_header() do
    case :ets.lookup(:iyzico, "auth_header") do
      [{auth_header, pid}] ->
        {'Authorization', auth_header}
      [] ->
        raise Iyzico.InternalInconsistencyError, reason: "ETS lookup failed."
    end
  end

  defp normalize_response(response) do
    case response do
      {:ok, {{_httpvs, 200, _status_phrase}, json_body}} ->
        {:ok, json_body}
      {:ok, {{_httpvs, 200, _status_phrase}, _headers, json_body}} ->
        {:ok, json_body}
      {:ok, {{_httpvs, status, _status_phrase}, json_body}} ->
        {:error, status, json_body}
      {:ok, {{_httpvs, status, _status_phrase}, _headers, json_body}} ->
        {:error, status, json_body}
      {:error, reason} -> {:error, :bad_fetch, reason}
    end
  end
end
