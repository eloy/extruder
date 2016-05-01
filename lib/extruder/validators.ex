defmodule Extruder.Validators do

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
