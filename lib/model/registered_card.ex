defmodule Iyzico.RegisteredCard do
  @moduledoc """
  A module holding registered cards used in monetary transactions.
  """

  @enforce_keys ~w(user_key token)a

  defstruct [
    :user_key,
    :token
  ]

  @typedoc """
  Represents a registered card to perform the checkout.

  ## Fields

  - `:user_key`: The value created by Iyzico for the user.
  - `:token`: The value created by Iyzico for the current card.
  """
  @type t :: %__MODULE__{
    user_key: binary,
    token: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.RegisteredCard do
  def to_iolist(data) do
    [{"cardToken", data.token},
     {"cardUserKey", data.user_key}]
  end
end
