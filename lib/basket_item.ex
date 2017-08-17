defmodule Iyzico.BasketItem do
  @moduledoc """
  Represents an item on a basket.
  """
  @enforce_keys ~w(id price name category subcategory type)a
  defstruct [
    :id,
    :price,
    :name,
    :category,
    :subcategory,
    :type,
    :valid?
  ]

  @type t :: %__MODULE__{
    id: binary,
    price: binary,
    name: binary,
    category: binary,
    subcategory: binary,
    type: binary,
    valid?: boolean
  }

  @spec put_identifier(t, integer) :: t
  def put_identifier(basket_item = %t{}, id) when is_integer(id) do
    put_identifier(basket_item, Integer.to_string(id))
  end
  @spec put_identifier(t, binary) :: t
  def put_identifier(basket_item = %t{}, id) when is_binary(id) do
    basket_item
    |> Map.put(:id, id)
    |> validate_struct()
  end

  @spec put_price(t, number) :: t
  def put_price(basket_item = %t{}, price) when is_number(price) do
    put_price(basket_item, Integer.to_string(price))
  end
  @spec put_price(t, binary) :: t
  def put_price(basket_item = %t{}, price) when is_binary(price) do
    basket_item
    |> Map.put(:price, price)
    |> validate_struct()
  end

  @spec put_name(t, binary) :: t
  def put_name(basket_item = %t{}, name) when is_binary(name) do
    basket_item
    |> Map.put(:name, name)
    |> validate_struct()
  end

  @spec put_category(t, binary) :: t
  def put_category(basket_item = %t{}, category) when is_binary(category) do
    basket_item
    |> Map.put(:category, category)
    |> validate_struct()
  end

  @spec put_subcategory(t, binary) :: t
  def put_subcategory(basket_item = %t{}, subcategory) when is_binary(subcategory) do
    basket_item
    |> Map.put(:subcategory, subcategory)
    |> validate_struct()
  end

  @spec make_virtual(t) :: t
  def make_virtual(basket_item = %t{}) do
    basket_item
    |> Map.put(:type, :virtual)
    |> validate_struct()
  end

  @spec make_physical(t) :: t
  def make_physical(basket_item = %t{}) do
    basket_item
    |> Map.put(:type, :physical)
    |> validate_struct()
  end

  defp validate_struct(basket_item = %t{}) do
    result =
      Enum.reduce(Map.keys(basket_item), fn(key, acc) ->
        not is_nil(Map.fetch(basket_item, key))
      end)

    Map.put(basket_item, :valid?, result)
  end
end
