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

  def put_identifier(buyer = %t{}, id) when is_binary(id) do
    buyer
    |> Map.put(:id, id)
    |> validate_struct()
  end

  def put_name(buyer = %t{}, name) when is_binary(name) do
    buyer
    |> Map.put(:name, name)
    |> validate_struct()
  end

  def put_surname(buyer = %t{}, surname) when is_binary(surname) do
    buyer
    |> Map.put(:surname, surname)
    |> validate_struct()
  end

  def put_identity_number(buyer = %t{}, identity_number) when is_binary(identity_number) do
    buyer
    |> Map.put(:identity_number, identity_number)
    |> validate_struct()
  end

  def put_email(buyer = %t{}, email) when is_binary(email) do
    buyer
    |> Map.put(:email, email)
    |> validate_struct()
  end

  def put_phone_number(buyer = %t{}, phone_number) when is_binary(phone_number) do
    buyer
    |> Map.put(:phone_number, phone_number)
    |> validate_struct()
  end

  def put_registration_date(buyer = %t{}, date) do
    buyer
    |> Map.put(:registration_date, date)
    |> validate_struct()
  end

  def put_last_login_date(buyer = %t{}, date) do
    buyer
    |> Map.put(:last_login_date, date)
    |> validate_struct()
  end

  def put_registration_address(buyer = %t{}, address) when is_binary(address) do
    buyer
    |> Map.put(:registration_address, address)
    |> validate_struct()
  end

  def put_city(buyer = %t{}, city) when is_binary(city) do
    buyer
    |> Map.put(:city, city)
    |> validate_struct()
  end

  def put_country(buyer = %t{}, country) when is_binary(country) do
    buyer
    |> Map.put(:country, country)
    |> validate_struct()
  end

  def put_zip_code(buyer = %t{}, zip_code) when is_binary(zip_code) do
    buyer
    |> Map.put(:zip_code, zip_code)
    |> validate_struct()
  end

  def put_ip(buyer = %t{}, ip) when is_tuple(ip) do
    buyer
    |> Map.put(:ip, ip)
    |> validate_struct()
  end

  defp validate_struct(buyer = %t{}) do
    result =
      Enum.reduce(Map.keys(buyer), fn (key, acc) ->
        not is_nil(Map.fetch(buyer, key))
      end)

    Map.put(buyer, :valid?, result)
  end
end
