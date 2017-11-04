defmodule Iyzico.AddCardRegistrationRequest do
  @moduledoc false
  @doc false
  @enforce_keys ~w(conversation_id card_user_key card)a

  defstruct [
    :locale,
    :conversation_id,
    :card_user_key,
    :card
  ]

  @type t :: %__MODULE__{
    locale: binary,
    conversation_id: binary,
    card_user_key: binary,
    card: Iyzico.Card.t,
  }

  defimpl Iyzico.IOListConvertible, for: Iyzico.AddCardRegistrationRequest do
    @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

    def to_iolist(data) do
      [{"locale", @default_locale},
       {"conversationId", data.conversation_id},
       {"cardUserKey", data.card_user_key},
       {"card", Iyzico.IOListConvertible.to_iolist(data.card)}]
    end
  end
end
