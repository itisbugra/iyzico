defmodule Iyzico.InternalInconsistencyError do
  defexception [:reason]

  def exception(reason) do
    %Iyzico.InternalInconsistencyError{reason: reason}
  end

  def message(_exception) do
    "Unexpected error."
  end
end
