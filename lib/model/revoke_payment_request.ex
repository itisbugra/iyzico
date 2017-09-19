defmodule Iyzico.RevokePaymentRequest do
  @moduledoc false
  @doc false

  @enforce_keys ~w(conversation_id payment_id ip)a

  defstruct [
    :conversation_id,
    :payment_id,
    :ip
  ]

  @typedoc false
  @type t :: %__MODULE__{
    conversation_id: binary,
    payment_id: binary,
    ip: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.RevokePaymentRequest do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"paymentId", data.payment_id},
     {"ip", Enum.join(Tuple.to_list(data.ip), ".")}]
  end
end
