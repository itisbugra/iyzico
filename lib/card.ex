defmodule Iyzico.Card do
  @moduledoc """
  Represents a card to perform the checkout.
  """

  @enforce_keys ~w(holder_name number exp_year exp_month cvc)a
  defstruct [
    :holder_name,
    :number,
    :exp_year,
    :exp_month,
    :cvc
  ]

  @type t :: %__MODULE__{
    holder_name: binary,
    number: binary,
    exp_year: integer,
    exp_month: integer,
    cvc: integer
  }

  def put_holder_name(card = %t{}, name) when is_binary(name) do
    card
    |> Map.put(:holder_name, name)
    |> validate_struct()
  end

  def put_number(card = %t{}, number) when is_binary(number) do
    card
    |> Map.put(:number, number)
    |> validate_struct()
  end

  def put_exp_year(card = %t{}, year) when is_integer(year) do
    card
    |> Map.put(:year, year)
    |> validate_struct()
  end

  def put_exp_month(card = %t{}, month) when is_integer(month) do
    card
    |> Map.put(:exp_month, month)
    |> validate_struct()
  end

  def put_cvc(card = %t{}, cvc) when is_number(cvc) do
    card
    |> Map.put(:cvc, cvc)
    |> validate_struct()
  end

  defp validate_struct(card = %t{}) do
    result =
      Enum.reduce(Map.keys(card), fn(key, acc) ->
        not is_nil(Map.fetch(card, key))
      end)

    Map.put(card, :valid?, result)
  end

  defp validate_number(number) when is_binary(number) do
    Luhn.valid? number
  end

  defp validate_cvc(cvc) when is_integer(cvc) do
    cvc >= 100 and cvc < 1000
  end
end
