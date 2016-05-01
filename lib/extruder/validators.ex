defmodule Extruder.Validators do

  defmacro validates_presence_of(field) do
    quote do
      f = unquote(field)
      field_validations = @__extruder__.validations[f] || []
      field_validations = field_validations ++ [{:presence, []}]
      validations = @__extruder__.validations ++ [{f, field_validations}]
      @__extruder__ %{@__extruder__ | validations:  validations}
    end
  end

  def run(validations, value) do
    case run_validations(validations, value) do
      {value, []} -> {:ok, value}
      {value, errors} -> {:error, errors, value}
    end
  end

  defp run_validations(validations, value) do
    Enum.reduce validations, {value, []}, &run_validation(&1, &2)
  end


  defp run_validation({:presence, opt}, {value, errors})  do
    case value == nil do
      false -> {value, errors}
      true ->
        errors = errors ++ [:can_not_be_nil]
        {value, errors}
    end
  end
end
