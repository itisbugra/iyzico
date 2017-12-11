defmodule Iyzico.InternalInconsistencyError do
  defexception [:reason, :code]

  def exception(reason, code) do
    %Iyzico.InternalInconsistencyError{reason: reason, code: code}
  end

  def message(_exception) do
    "Unexpected error."
  end
end
