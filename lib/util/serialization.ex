defmodule Iyzico.Serialization do
  @moduledoc """
  Provides serialization function in order to serialize the body to be consisted in authentication header.
  """
  def serialize(value) when is_list(value) do
    serialize(nil, value)
  end

  defp serialize(key, value) when is_list(value) do
    aggregate =
      value
      |> Enum.map(fn {key, value} -> serialize(key, value) end)

    cond do
      Enum.at(value, 0) |> elem(0) |> is_integer() ->
        serialize(key, "[#{Enum.join(aggregate, ", ")}]")
      true ->
        serialize(key, "[#{Enum.join(aggregate, ",")}]")
    end
  end

  defp serialize(key, value) when is_binary(key) do
    "#{key}=#{value}"
  end

  defp serialize(_key, value) do
    value
  end

  def to_json(value) when is_list(value) do
    to_json(nil, value)
  end

  def to_json(key, value) when is_integer(key) and is_list(value) do
    aggregate =
      value
      |> Enum.map(fn {key, value} -> to_json(key, value) end)
      |> Enum.join(",")

    "{#{aggregate}}"
  end

  def to_json(key, value) when is_list(value) do
    aggregate =
      value
      |> Enum.map(fn {key, value} -> to_json(key, value) end)
      |> Enum.join(",")

    cond do
      is_nil(key) ->
        "{#{aggregate}}"
      Enum.at(value, 0) |> elem(0) |> is_integer() ->
        "\"#{key}\":[#{aggregate}]"
      true ->
        "\"#{key}\":{#{aggregate}}"
    end
  end

  def to_json(key, value) when is_binary(key) and is_binary(value) do
    "\"#{key}\":\"#{value}\""
  end

  def to_json(key, value) when is_binary(key) and is_integer(value) do
    "\"#{key}\":#{value}"
  end

  def to_json(_key, value) do
    value
  end
end
