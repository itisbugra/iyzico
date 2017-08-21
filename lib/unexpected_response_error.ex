defmodule Iyzico.UnexpectedResponseError do
  defexception [:resp]

  def exception(resp) do
    %Iyzico.UnexpectedResponseError{resp: resp}
  end
end
