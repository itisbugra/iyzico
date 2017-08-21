defmodule Iyzico.EndpointCase do
  use ExUnit.CaseTemplate

  @status_field "status"

  using do
    quote do
      import Iyzico.EndpointCase
    end
  end

  defmacro assert_resp_success(resp) do
    quote do
      result = unquote(resp)

      assert result["status"] == "success"

      result
    end
  end
end
