defmodule Iyzico.Address do
  @moduledoc """
  Represents an address belonging to stakeholders of a payment (i.e. buyer, seller).
  """
  @enforce_keys ~w(address zip contact_name city country)a
  defstruct [
    :address,
    :zip,
    :contact_name,
    :city,
    :country
  ]

  @type t :: %__MODULE__{
    address: binary,
    zip: binary,
    contact_name: binary,
    city: binary,
    country: binary
  }
end
