defmodule Extruder.Builder do

  def assign(model_def, struct, params) do
    Enum.reduce model_def.fields, {struct, %{}} , fn({name, type, opt}, {struct, errors}) ->
      # if params include a value, set it, leave the default value otherwise
      raw_value = get_value(struct, params, name)

      case cast(type, raw_value, opt) do
        {:error, field_errors} ->
          {struct, add_error(errors, name, field_errors)}
        value ->
          struct = %{struct | name => value}
          {struct, errors}
      end
    end
  end

  def validate(model_def, struct, params, errors) do
    Enum.reduce model_def.fields, errors, fn({name, type, opt}, errors) ->
      validations = model_def.validations[name] || []
      case Extruder.Validators.run(validations, struct, name, opt) do
        [] -> errors
        field_errors -> add_error(errors, name, field_errors)
      end
    end
  end

  defp add_error(errors, field_name, error) do
    case Map.get errors, field_name do
      nil -> Map.put errors, field_name, error
      other_errors -> Map.put errors, field_name, other_errors ++ error
    end
  end

  defp get_value(struct, params, name) do
    name_str = Atom.to_string(name)
    cond do
      Map.has_key?(params, name) -> Map.fetch! params, name
      Map.has_key?(params, name_str) -> Map.fetch! params, name_str
      true -> Map.get struct, name
    end
  end


  # Cast
  #----------------------------------------------------------------------


  defp cast(_type, nil, _field_opt), do: nil
  defp cast(_type, :empty, _field_opt), do: :empty

  # int
  #----------------------------------------------------------------------

  defp cast(:int, "", _field_opt), do: nil

  defp cast(:int, value, _field_opt) when is_number(value) do
    value
  end

  defp cast(:int, value, _field_opt)  do
    case Integer.parse value do
      {value, _rest} -> value
      :error -> {:error, [:is_not_a_number]}
    end
  end


  # float
  #----------------------------------------------------------------------


  defp cast(:float, "", _field_opt), do: nil

  defp cast(:float, value, _field_opt) when is_number(value) do
    value
  end

  defp cast(:float, value, _field_opt)  do
    case Float.parse value do
      {value, _rest} -> value
      :error -> {:error, [:is_not_a_number]}
    end
  end


  # UUID
  #----------------------------------------------------------------------

  defp cast(:uuid, value, _field_opt)  do
    case is_binary(value) do
      true -> value
      false -> {:error, [:is_not_a_UUID]}
    end
  end


  # strings
  #----------------------------------------------------------------------

  defp cast(:string, value, _field_opt)  do
    case is_binary(value) do
      true -> value
      false -> {:error, [:is_not_an_string]}
    end
  end


  # map
  #----------------------------------------------------------------------

  defp cast(:map, value, _field_opt)  do
    case is_map(value) do
      true -> value
      false -> {:error, [:is_not_a_map]}
    end
  end

  # list
  #----------------------------------------------------------------------

  defp cast(:list, value, _field_opt)  do
    case is_list(value) do
      true -> value
      false -> {:error, [:is_not_a_list]}
    end
  end


  # boolean
  #----------------------------------------------------------------------

  defp cast(:boolean, value, _field_opt)  do
    case is_boolean(value) do
      true -> value
      false -> {:error, [:is_not_a_boolean]}
    end
  end


  # Atoms
  #----------------------------------------------------------------------

  defp cast(:atom, value, _field_opt) when is_atom(value) do
    value
  end

  defp cast(:atom, value, _field_opt) when is_bitstring(value) do
    try do
      String.to_existing_atom value
    rescue
      _e in ArgumentError ->
        {:error, [:is_not_an_existing_atom]}
    end
  end

  # Struct
  #----------------------------------------------------------------------

  defp cast(:struct, value, field_opt) when is_map(value) do
    module = field_opt[:module]
    case module.extrude value do
      {:ok, struct} -> struct
      {:error, struct, field_errors} -> {:error, field_errors}
    end
  end

  defp cast(:struct, value, _field_opt), do: {:error, [:is_not_an_struct]}


  # Structs List
  #----------------------------------------------------------------------


  defp cast(:structs_list, value, field_opt) when is_list(value) do
    module = field_opt[:module]
    {structs, neested_errors, _index} = Enum.reduce value, {[], %{}, 0}, fn(s, {structs, neested_errors, index}) ->
      case module.extrude s do
        {:ok, struct} ->
          structs = structs ++ [struct]
          {structs, neested_errors, index}
        {:error, struct, e} ->
          structs = structs ++ [struct]
          neested_errors = add_error(neested_errors, index, e)
          {structs, neested_errors, index}
      end
    end


    if map_size(neested_errors) == 0  do
      structs
    else
      {:error, neested_errors}
    end
  end

  defp cast(:structs_list, value, _field_opt), do: {:error, [:is_not_a_list]}

  # Structs Map
  #----------------------------------------------------------------------

  defp cast(:structs_map, value, field_opt) when is_map(value) do
    module = field_opt[:module]
    {structs_map, neested_errors} = Enum.reduce value, {%{}, %{}}, fn({key, s}, {structs_map, neested_errors}) ->
      case module.extrude s do
        {:ok, struct} ->
          structs_map = Map.put structs_map, key, struct
          {structs_map, neested_errors}
        {:error, struct, e} ->
          structs_map = Map.put structs_map, key, struct
          neested_errors = add_error(neested_errors, key, e)
          {structs_map, neested_errors}
      end
    end

    if map_size(neested_errors) == 0  do
      structs_map
    else
      {:error, neested_errors}
    end
  end

  defp cast(:structs_map, value, _field_opt), do: {:error, [:is_not_a_map]}

  # Datetime
  #----------------------------------------------------------------------

  defp cast(:datetime, "", field_opt),  do: nil

  defp cast(:datetime, value, field_opt) when is_bitstring(value) do
    case Timex.parse(value, "{ISO:Extended:Z}") do
      {:ok, value} -> value
      {:error, e} -> {:error, ["Invalid date"]}
    end
  end

  defp cast(:datetime, value, field_opt), do: value

  # Custom
  #----------------------------------------------------------------------


  defp cast(:custom, value, field_opt) do
    parse = field_opt[:parse]
    case parse.(value) do
      {:ok, value} -> value
      {:error, e} -> {:error, [e]}
    end
  end


end
