defmodule Extruder.ValidationHelpers do

  defmacro validates(field, validator, opts \\ []) do
    quote do
      f = unquote(field)
      field_validations = @__extruder__.validations[f] || []
      field_validations = field_validations ++ [{unquote(validator), unquote(opts)}]
      validations = @__extruder__.validations ++ [{f, field_validations}]
      @__extruder__ %{@__extruder__ | validations:  validations}
    end
  end

  defmacro validates_presence_of(field) do
    quote do
      validates(unquote(field), :presence)
    end
  end

end
