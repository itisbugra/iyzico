defmodule Iyzico.PaymentProcessingError do
  defexception [:code]

  def exception(code) do
    %Iyzico.PaymentProcessingError{code: code}
  end

  def message(_exception) do
    "Payment could not be processed successfully."
  end
end
