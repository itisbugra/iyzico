defmodule Iyzico.CardRegistrationRequest do
  @doc false
  @enforce_keys ~w(conversation_id external_id email card)a

  defstruct [
    :locale,
    :conversation_id,
    :external_id,
    :email,
    :card
  ]

  @type t :: %__MODULE__{
    locale: binary,
    conversation_id: binary,
    external_id: binary,
    email: binary,
    card: Iyzico.Card.t,
  }

  defimpl Iyzico.IOListConvertible, for: Iyzico.CardRegistrationRequest do
    @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

    def to_iolist(data) do
      [{"locale", @default_locale},
       {"conversationId", data.conversation_id},
       {"externalId", data.external_id},
       {"email", data.email},
       {"card", Iyzico.IOListConvertible.to_iolist(data.card)}]
    end
  end
end
