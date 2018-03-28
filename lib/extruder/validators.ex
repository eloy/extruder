defmodule Extruder.Validators do


  def run(validations, struct, name, field_opt) do
    Enum.reduce validations, [], fn(validation, errors) ->
      run_validation(validation, struct, name, field_opt, errors)
    end
  end


  defp run_validation({:presence, opt}, struct, name, _field_opt, errors)  do
    value = Map.get struct, name

    if is_nil(value) do
      errors ++ [:can_not_be_nil]
    else
      errors
    end
  end

  defp run_validation({:inclussion, [in: permitted]}, struct, name, _field_opt, errors)  do
    value = Map.get struct, name
    if is_nil(value) || value in permitted do
      errors
    else
      errors ++ [:is_not_permitted]
    end
  end


  defp run_validation({custom_validator, validator_opt}, struct, name, _field_opt, errors)  do
    case apply(struct.__struct__, custom_validator, [name, struct, validator_opt]) do
      {:error, error} -> errors ++ [error]
      :ok -> errors
    end
  end
end
