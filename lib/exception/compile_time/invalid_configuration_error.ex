defmodule Iyzico.InvalidConfigurationError do
  @doc false
  defexception [:message]

  def exception(param) do
    %Iyzico.InvalidConfigurationError{message: param}
  end

  def message(_exception) do
    "Invalid configuration parameter."
  end
end
