defmodule Iyzico.UnexpectedResponseError do
  defexception [:resp]

  def exception(resp) do
    %Iyzico.UnexpectedResponseError{resp: resp}
  end

  def message(exception) do
    "unexpected response: #{exception.resp}"
  end
end
