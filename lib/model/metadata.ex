defmodule Iyzico.Metadata do
  @typedoc """
  Provides metadata of a response from server.
  """

  @enforce_keys ~w(system_time succeed? locale)a

  defstruct [
    :system_time,
    :succeed?,
    :phase,
    :locale,
    :auth_code
  ]

  @type t :: %__MODULE__{
    system_time: integer,
    succeed?: boolean,
    phase: atom,
    locale: binary,
    auth_code: binary
  }
end
