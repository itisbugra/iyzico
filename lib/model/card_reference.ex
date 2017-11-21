defmodule Iyzico.CardReference do
  @moduledoc """
  A module representing a reference to a stored card.
  """

  @enforce_keys ~w(type assoc family)a

  defstruct [
    :alias,
    :user_key,
    :token,
    :email,
    :card,
    :type,
    :assoc,
    :family,
    :bank_name,
    :bank_code,
    :bin_number
  ]

  @typedoc """
  Represents a reference to a stored card.
  """
  @type t :: %__MODULE__{
    alias: binary,
    user_key: binary,
    token: binary,
    email: binary,
    card: Iyzico.Card.t | Iyzico.RegisteredCard.t,
    type: Iyzico.Card.card_type,
    assoc: Iyzico.Card.card_assoc,
    family: Iyzico.Card.card_family,
    bank_name: binary,
    bank_code: number,
    bin_number: binary
  }
end
