defmodule Iyzico.Address do
  @moduledoc """
  Represents an address belonging to stakeholders of a payment (i.e. buyer, seller).
  """
  @enforce_keys ~w(address zip_code contact_name city country)a
  defstruct [
    :address,
    :zip_code,
    :contact_name,
    :city,
    :country,
    :valid?
  ]

  @type t :: %__MODULE__{
    address: binary,
    zip_code: binary,
    contact_name: binary,
    city: binary,
    country: binary,
    valid?: boolean
  }

  defp validate_struct(address = %Iyzico.Address{}) do
    result =
      Enum.reduce(Map.keys(address), fn (key, acc) ->
        not is_nil(Map.fetch(address, key))
      end)

    Map.put(address, :valid?, result)
  end

  defmodule View do
    def render_iolist(address = %Iyzico.Address{}) do
      [{"address", address.address},
       {"zipCode", address.zip_code},
       {"contactName", address.contact_name},
       {"city", address.city},
       {"country", address.country}]
    end
  end
end
