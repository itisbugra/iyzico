defmodule Iyzico.CardNotRegisteredError do
  defexception [:message]

  def exception(_opts) do
    %Iyzico.CardNotRegisteredError{}
  end

  def message(exception) do
    "Card was not registered on remote host."
  end
end
