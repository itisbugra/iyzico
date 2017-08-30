defmodule Iyzico.CardReference do
  @doc """
  Represents a reference to a stored card.
  """

  @enforce_keys ~w(alias user_key token type assoc family)a

  defstruct [
    :alias,
    :user_key,
    :token,
    :email,
    :card,
    :type,
    :assoc,
    :family,
    :bank_name
  ]

  @type t :: %__MODULE__{
    alias: binary,
    user_key: binary,
    token: binary,
    email: binary,
    card: Iyzico.Card.t,
    type: Iyzico.Card.card_type,
    assoc: Iyzico.Card.card_assoc,
    family: Iyzico.Card.card_family,
    bank_name: binary
  }
end
