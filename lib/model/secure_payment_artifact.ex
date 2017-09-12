defmodule Iyzico.SecurePaymentArtifact do
  @moduledoc """
  
  """
  @enforce_keys ~w(conversation_id page_body)a
  
  defstruct [
    :conversation_id,
    :page_body
  ]
  
  @type t :: %__MODULE__{
    conversation_id: binary,
    page_body: binary
  }
end