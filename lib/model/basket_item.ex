defmodule Iyzico.BasketItem do
  @moduledoc """
  A module for representing an item on a shopping basket to be processed in payment.
  """

  @enforce_keys ~w(id price name category subcategory type)a
  defstruct [
    :id,
    :price,
    :name,
    :category,
    :subcategory,
    :type
  ]

  @typedoc """
  The type of an item by its tangibility. A physical item should be tangible.
  """
  @type type :: :physical | :virtual

  @typedoc """
  Represents an item on a basket.

  ## Fields

  - `:id`: Identifier of an item to be queried in host platform in future. It had better be unique.
  - `:price`: Price of the item.
  - `:name`: Name of the item, *(e.g.: Binoculars)*.
  - `:category`: Category of the item, *(e.g.: Collectibles)*.
  - `:subcategory`: Subcategory of the item, *(.e.g.: Accessories)*.
  - `:type`: Type of the item, check out type `type` for more information.
  """
  @type t :: %__MODULE__{
    id: binary,
    price: binary,
    name: binary,
    category: binary,
    subcategory: binary,
    type: type
  }

  @doc """
  Path for given item.

  ## Examples

      iex> Iyzico.BasketItem.path(%Iyzico.BasketItem{id: "3", price: "45.72", name: "Binoculars", category: "Collectibles", subcategory: "Accessories", type: :physical})
      "Collectibles/Accessories/Binoculars/3"
  """
  @spec path(Iyzico.BasketItem.t) :: String.t
  def path(item = %Iyzico.BasketItem{}) do
    "#{item.category}/#{item.subcategory}/#{item.name}/#{item.id}"
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
