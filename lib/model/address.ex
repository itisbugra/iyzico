defmodule Iyzico.Address do
  @typedoc """
  Represents an address belonging to stakeholders of a payment (i.e. buyer, seller).
  """
  @enforce_keys ~w(address zip_code contact_name city country)a
  defstruct [
    :address,
    :zip_code,
    :contact_name,
    :city,
    :country
  ]

  @type t :: %__MODULE__{
    address: binary,
    zip_code: binary,
    contact_name: binary,
    city: binary,
    country: binary
  }
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Address do
  def to_iolist(data) do
    [{"address", data.address},
     {"zipCode", data.zip_code},
     {"contactName", data.contact_name},
     {"city", data.city},
     {"country", data.country}]
  end
end
