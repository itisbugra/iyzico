defmodule Iyzico.Iyzipay do
  import Iyzico.Client

  @doc """
  Processes the given payment request on the remote API.
  """
  def process_payment_req(payment = %Iyzico.PaymentRequest{}) do
    request([], :post, url_for_path("/payment/auth"), [], payment)
  end

  @doc """
  Same as `process_payment_req/1`, but raises an `Iyzico.PaymentProcessingError` exception in case of failure.
  Otherwise returns successfully processed payment.
  """
  def process_payment_req!(payment = %Iyzico.PaymentRequest{}) do
    case process_payment_req(payment) do
      {:ok, payment} ->
        payment
      {:error, code} ->
        raise Iyzico.PaymentProcessingError, code: code
    end
  end
end
