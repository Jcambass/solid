defmodule Solid.Argument do
  @moduledoc """
  An Argument can be a field that will be inside the context or
  a value (String, Integer, etc)
  """

  alias Solid.Context

  @doc """
  iex> Solid.Argument.get({:field, ["key"]}, %Solid.Context{vars: %{"key" => 123}})
  123
  iex> Solid.Argument.get({:field, ["key1", "key2"]}, %Solid.Context{vars: %{"key1" => %{"key2" => 123}}})
  123
  iex> Solid.Argument.get({:value, "value"}, %Solid.Context{})
  "value"
  iex> Solid.Argument.get({:field, ["key"], [{:access, 1},{:access, 1}]}, %Solid.Context{vars: %{"key" => [1, [1,2,3], 3]}})
  2
  iex> Solid.Argument.get({:field, ["key"], [{:access, 1}]}, %Solid.Context{vars: %{"key" => "a string"}})
  nil
  """
  @spec get({:field, [String.t()]} | {:field, [String.t()], [{:access, non_neg_integer}]} | {:value, term}, Context.t, [atom]) :: term
  def get(field, context, scopes \\ [:vars, :counter_vars])
  def get({:value, val}, _hash, _scopes), do: val
  def get({:field, key}, context, scopes) do
    Context.get_in(context, key, scopes)
  end
  def get({:field, key, accesses}, context, scopes) do
    value = get({:field, key}, context, scopes)
    Enum.reduce(accesses, value,
                fn {:access, index}, acc when is_list(acc) ->
                     Enum.at(acc, index)
                   _, _ -> nil
                end)
  end
end
