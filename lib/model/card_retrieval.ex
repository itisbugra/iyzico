defmodule Iyzico.CardRetrieval do
  @moduledoc false
  @enforce_keys ~w(conversation_id user_key)a

  defstruct [
    :conversation_id,
    :user_key
  ]

  @type t :: %__MODULE__{
    conversation_id: binary,
    user_key: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.CardRetrieval do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"cardUserKey", data.user_key}]
  end
end
