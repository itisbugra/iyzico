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
      assert unquote(resp)["status"] == "success"

      unquote(resp)
    end
  end
end
