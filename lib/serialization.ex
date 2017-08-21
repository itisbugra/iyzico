defmodule Iyzico.Serialization do
  @moduledoc """
  Provides serialization function in order to serialize the body to be consisted in authentication header.
  """

  @spec serialize(map) :: String.t
  def serialize(body) when is_map(body) do
    coder = body
    |> Enum.map(&serialize_elem/1)
    |> Enum.join(",")

    "[#{coder}]"
  end

  defp serialize_elem({key, value}), do: serialize_field(key, value)

  defp serialize_field(key, value) when is_list(value), do:
    "#{key}=[#{Enum.map(value, &serialize/1) |> Enum.join(", ")}]"
  defp serialize_field(key, value) when is_map(value), do:
    "#{key}=#{serialize(value)}"
  defp serialize_field(key, value), do:
    "#{key}=#{value}"
end
