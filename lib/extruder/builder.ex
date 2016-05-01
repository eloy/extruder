defmodule Extruder.Builder do

  def sanitize(model_def, struct, params) do
    Enum.reduce model_def.fields, {struct, []}, fn({name, type, opt}, {struct, errors}) ->
      # if params include a value, set it, leave the default value otherwise
      value = get_value(params, name)
      if value != :empty do
        struct = %{struct | name => value}
      end

      # run validations
      validations = model_def.validations[name]
      if validations != nil do
        case Extruder.Validators.run(validations, Map.fetch!(struct, name)) do
          {:ok, ret_value} -> struct = %{struct | name => ret_value}
          {:error, field_errors, _ret_value} -> errors = errors ++ [{name, field_errors}]
        end
      end

      {struct, errors}
    end
  end

  defp get_value(params, name) do
    name_str = Atom.to_string(name)
    cond do
      Map.has_key?(params, name) -> params[name]
      Map.has_key?(params, name_str) -> params[name_str]
      true -> :empty
    end
  end
end
