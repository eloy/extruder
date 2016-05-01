defmodule Extruder.Builder do
  def sanitize(struct, fields, params) do
    Enum.reduce fields, {struct, []}, fn({name, type, opt}, {struct, errors}) ->
      name_str = Atom.to_string(name)
      value = params[name] || params[name_str]
      if value do
        struct = %{struct | name => value}
      end
      {struct, errors}
    end
  end
end
