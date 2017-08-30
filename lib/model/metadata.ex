defmodule Iyzico.Metadata do
  @moduledoc """
  A module containing request metadata related utilities.
  """

  @enforce_keys ~w(system_time succeed? locale)a

  defstruct [
    :system_time,
    :succeed?,
    :phase,
    :locale,
    :auth_code
  ]

  @typedoc """
  Provides metadata of a response from server.

  ## Fields:

  - `:system_time`: System epoch in milliseconds.
  - `:succeed?`: Boolean value indicating success of operation.
  - `:phase`: `:auth` if request was authorized successfully, else `nil`.
  - `:locale`: Locale of the response.
  - `:auth_code`: Authentication related string returned in response.
  """
  @type t :: %__MODULE__{
    system_time: integer,
    succeed?: boolean,
    phase: atom,
    locale: binary,
    auth_code: binary
  }
end
