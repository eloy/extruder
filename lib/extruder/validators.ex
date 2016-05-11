defmodule Extruder.Validators do

  def run(validations, value, opt) do
    case run_validations(validations, value, opt) do
      {value, []} -> {:ok, value}
      {value, errors} -> {:error, errors, value}
    end
  end

  defp run_validations(validations, value, field_opt) do
    Enum.reduce validations, {value, []}, &run_validation(&1, field_opt, &2)
  end


  defp run_validation({:presence, opt}, _field_opt, {value, errors})  do
    case is_nil(value) do
      false -> {value, errors}
      true ->
        errors = errors ++ [:can_not_be_nil]
        {value, errors}
    end
  end


  # Cast
  #----------------------------------------------------------------------

  defp run_validation({:cast, _type}, _field_opt, {nil, errors})  do
    {nil, errors}
  end

  defp run_validation({:cast, :int}, _field_opt, {value, errors})  do
    case is_number(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_number]
        {value, errors}
    end
  end

  defp run_validation({:cast, :string}, _field_opt, {value, errors})  do
    case is_binary(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_an_string]
        {value, errors}
    end
  end

  defp run_validation({:cast, :map}, _field_opt, {value, errors})  do
    case is_map(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_map]
        {value, errors}
    end
  end

  defp run_validation({:cast, :list}, _field_opt, {value, errors})  do
    case is_list(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_map]
        {value, errors}
    end
  end

  defp run_validation({:cast, :boolean}, _field_opt, {value, errors})  do
    case is_boolean(value) do
      true -> {value, errors}
      false ->
        errors = errors ++ [:is_not_a_boolean]
        {value, errors}
    end
  end


  # Atoms
  #----------------------------------------------------------------------

  defp run_validation({:cast, :atom}, _field_opt, {value, errors}) when is_atom(value) do
    {value, errors}
  end

  defp run_validation({:cast, :atom}, _field_opt, {value, errors}) when is_bitstring(value) do
    try do
      value = String.to_existing_atom value
      {value, errors}
    rescue
      _e in ArgumentError ->
        errors = errors ++ [:is_not_an_existing_atom]
        {value, errors}
    end
  end

  # Struct
  #----------------------------------------------------------------------

  defp run_validation({:cast, :struct}, _field_opt, {value, errors}) when is_nil(value) do
    {nil, errors}
  end


  defp run_validation({:cast, :struct}, field_opt, {value, errors}) when is_map(value) do
    module = field_opt[:module]
    case module.extrude value do
      {:ok, struct} ->
        {struct, errors}
      {:error, struct, field_errors} ->
        {value, (errors ++ field_errors)}
    end
  end

  defp run_validation({:cast, :struct}, _field_opt, {value, errors}) do
    errors = errors ++ [:is_not_an_struct]
    {value, errors}
  end

end
