defmodule Iyzico.CardRemoval do
  @moduledoc false
  @enforce_keys ~w(conversation_id user_key token)a

  defstruct [
    :conversation_id,
    :user_key,
    :token
  ]

  @type t :: %__MODULE__{
    conversation_id: binary,
    user_key: binary,
    token: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.CardRemoval do
  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  def to_iolist(data) do
    [{"locale", @default_locale},
     {"conversationId", data.conversation_id},
     {"cardUserKey", data.user_key},
     {"cardToken", data.token}]
  end
end
