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

  @type type :: :physical | :virtual

  @type t :: %__MODULE__{
    id: binary,
    price: binary,
    name: binary,
    category: binary,
    subcategory: binary,
    type: type,
    valid?: boolean
  }

  alias Iyzico.BasketItem

  defp validate_struct(basket_item = %BasketItem{}) do
    result =
      Enum.reduce(Map.keys(basket_item), fn(key, acc) ->
        acc and (not is_nil(Map.fetch(basket_item, key)))
      end)

    Map.put(basket_item, :valid?, result)
  end
end

defimpl Iyzico.IOListConvertible, for: Iyzico.BasketItem do
  def to_iolist(data) do
    [{"id", data.id},
     {"price", data.price},
     {"name", data.name},
     {"category1", data.category},
     {"category2", data.subcategory},
     {"itemType", Atom.to_string(data.type) |> String.upcase()}]
  end
end
