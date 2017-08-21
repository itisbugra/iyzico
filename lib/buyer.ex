defmodule Iyzico.Buyer do
  @moduledoc """
  Represents a peer party of a transactional operation.
  """
  @enforce_keys ~w(id name surname identity_number
                   email phone_number registration_date
                   last_login_date registration_address
                   city country zip_code ip)a
  defstruct [
    :id,
    :name,
    :surname,
    :identity_number,
    :email,
    :phone_number,
    :registration_date,
    :last_login_date,
    :registration_address,
    :city,
    :country,
    :zip_code,
    :ip
  ]

  @type t :: %__MODULE__{
    id: binary,
    name: binary,
    surname: binary,
    identity_number: binary,
    email: binary,
    phone_number: binary,
    registration_date: :naive_datetime,
    last_login_date: :naive_datetime,
    registration_address: binary,
    city: binary,
    country: binary,
    zip_code: binary,
    ip: tuple
  }

  defp validate_struct(buyer = %Iyzico.Buyer{}) do
    result =
      Enum.reduce(Map.keys(buyer), fn (key, acc) ->
        not is_nil(Map.fetch(buyer, key))
      end)

    Map.put(buyer, :valid?, result)
  end
end

defimpl Iyzico.IOListConvertible, for: Iyzico.Buyer do
  def to_iolist(data) do
    [{"id", data.id},
     {"name", data.name},
     {"surname", data.surname},
     {"identityNumber", data.identity_number},
     {"email", data.email},
     {"gsmNumber", data.phone_number},
     {"registrationDate", data.registration_date},
     {"lastLoginDate", data.last_login_date},
     {"registrationAddress", data.registration_address},
     {"city", data.city},
     {"country", data.country},
     {"zipCode", data.zip_code},
     {"ip", data.ip}]
  end
end
