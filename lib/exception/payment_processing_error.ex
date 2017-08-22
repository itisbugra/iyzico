defmodule Iyzico.PaymentProcessingError do
  defexception [:code]

  def exception(code) do
    %Iyzico.PaymentProcessingError{code: code}
  end
end
