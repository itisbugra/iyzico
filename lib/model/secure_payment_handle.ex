defmodule Iyzico.SecurePaymentHandle do
  @enforce_keys ~w(conversation_id payment_id conversation_data)a
  
  defstruct [
    :conversation_id,
    :payment_id,
    :conversation_data
  ]
  
  @type t :: %__MODULE__{
    conversation_id: binary,
    payment_id: binary,
    conversation_data: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.SecurePaymentHandle do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")
  
  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"paymentId", data.payment_id},
     {"conversationData", data.conversation_data}]
  end
end