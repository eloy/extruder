defmodule Extruder.Fields do
  defmacro field(name, type, opt \\ []) do
    quote do
      fields = @__extruder__.fields ++ [{unquote(name), unquote(type), unquote(opt)}]
      @__extruder__ %{@__extruder__ | fields: fields}
      validates(unquote(name), :cast, unquote(type))
    end
  end

  def struct_def(fields) do
    Enum.reduce fields, [], fn(f, d) ->
      d ++ [build_field(f)]
    end
  end


  def build_field({name, :int, opt}) do
    value = opt[:default] || nil
    {name, value}
  end

  def build_field({name, :string, opt}) do
    value = opt[:default] || nil
    {name, value}
  end

  def build_field({name, :boolean, opt}) do
    value = opt[:default] || false
    {name, value}
  end

  def build_field({name, :list, opt}) do
    value = opt[:default] || []
    {name, value}
  end

  def build_field({name, :map, opt}) do
    value = opt[:default] || %{}
    {name, value}
  end

  def build_field({name, :atom, opt}) do
    value = opt[:default] || nil
    {name, value}
  end

  def build_field({name, :struct, opt}) do
    value = opt[:default] || nil
    {name, value}
  end

  def build_field({name, :structs_list, opt}) do
    value = opt[:default] || nil
    {name, value}
  end

  def build_field({name, unknown, _opt}) do
    raise ":#{unknown} is not a valid type for the field #{name}"
  end


end
