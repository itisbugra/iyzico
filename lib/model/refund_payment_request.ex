defmodule Iyzico.RefundPaymentRequest do
  @moduledoc false
  @doc false
  @enforce_keys ~w(conversation_id transaction_id price ip currency)a

  defstruct [
    :conversation_id,
    :transaction_id,
    :price,
    :ip,
    :currency
  ]

  @typedoc false
  @type currency :: :try

  @typedoc false
  @type t :: %__MODULE__{
    conversation_id: binary,
    transaction_id: binary,
    price: binary,
    ip: tuple,
    currency: currency
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.RefundPaymentRequest do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"paymentTransactionId", data.transaction_id},
     {"price", data.price},
     {"ip", Enum.join(Tuple.to_list(data.ip), ".")},
     {"currency", Atom.to_string(data.currency) |> String.upcase()}]
  end
end
