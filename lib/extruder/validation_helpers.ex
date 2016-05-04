defmodule Extruder.ValidationHelpers do

  defmacro validates(field, validator, opts \\ []) do
    quote do
      f = unquote(field)
      validation = {unquote(validator), unquote(opts)}

      validations = case @__extruder__.validations[f] do
        nil ->
          @__extruder__.validations ++ [{f, [validation]}]
        field_validations ->
          field_validations = field_validations ++ [validation]
          List.keyreplace @__extruder__.validations, f, 0, {f, field_validations}
      end
      @__extruder__ %{@__extruder__ | validations:  validations}
    end
  end

  defmacro validates_presence_of(field) do
    quote do
      validates(unquote(field), :presence)
    end
  end

end
