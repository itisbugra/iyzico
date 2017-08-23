defmodule Iyzico.CardRegistrationError do
  defexception [:message]

  def exception(opts) do
    message = Keyword.fetch!(opts, :message)

    %Iyzico.CardRegistrationError{message: message}
  end

  def message(exception) do
    "Card could not be registered on remote host: #{exception.message}."
  end
end
