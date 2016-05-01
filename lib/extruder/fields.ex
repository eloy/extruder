defmodule Extruder.Fields do
  defmacro field(name, type, opt \\ []) do
    quote do
      @fields [{unquote(name), unquote(type), unquote(opt)} | @fields]
    end
  end

  def struct_def(fields) do
    Enum.reduce fields, [], fn(f, d) ->
      d ++ [build_field(f)]
    end
  end


  def build_field({name, :int, opt}) do
    value = opt[:default] || 0
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

end
