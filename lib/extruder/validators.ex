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
    case is_nil(value) do
      false -> {value, errors}
      true ->
        errors = errors ++ [:can_not_be_nil]
        {value, errors}
    end
  end


  # Cast
  #----------------------------------------------------------------------

  defp run_validation({:cast, _type}, {nil, errors})  do
    {nil, errors}
  end

  defp run_validation({:cast, :int}, {value, errors})  do
    case is_number(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_number]
        {value, errors}
    end
  end

  defp run_validation({:cast, :string}, {value, errors})  do
    case is_binary(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_an_string]
        {value, errors}
    end
  end

  defp run_validation({:cast, :map}, {value, errors})  do
    case is_map(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_map]
        {value, errors}
    end
  end

  defp run_validation({:cast, :list}, {value, errors})  do
    case is_list(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_map]
        {value, errors}
    end
  end

  defp run_validation({:cast, :boolean}, {value, errors})  do
    case is_boolean(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_boolean]
        {value, errors}
    end
  end

end
