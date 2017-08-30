defmodule Iyzico.CompileTime do
  @moduledoc false
  defmacro static_assert_binary(param) do
    quote do
      unless is_binary(unquote(param)) do
        raise Iyzico.InvalidConfigurationError
      end
    end
  end
end
