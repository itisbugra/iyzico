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

  defmodule View do
    def render_iolist(basket_item = %BasketItem{}) do
      [{"id", basket_item.id},
       {"price", basket_item.price},
       {"name", basket_item.name},
       {"category1", basket_item.category},
       {"category2", basket_item.subcategory},
       {"itemType", Atom.to_string(basket_item.type) |> String.upcase()}]
    end
  end
end
