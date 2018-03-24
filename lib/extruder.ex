defmodule Extruder do

  defmacro __using__(_opts) do
    quote do
      import Extruder
      @__extruder__ %{validations: [], fields: []}
    end
  end


  defmacro defmodel(block) do
    quote do
      import Extruder.ValidationHelpers
      import Extruder.Fields

      # Parse the fields
      unquote(block)

      # Build the struct
      defstruct struct_def(@__extruder__.fields)

      # add some helpers
      def extrude(params \\ %{})

      def extrude(nil) do
        extrude(%{})
      end

      def extrude(params) do
        struct = %__MODULE__{}
        {struct, errors} = Extruder.Builder.assign(@__extruder__, struct, params)
        errors = Extruder.Builder.validate(@__extruder__, struct, params, errors)

        if map_size(errors) == 0 do
          {:ok, struct} else
          {:error, struct, errors}
        end
      end

      def extrude!(params) do
        case extrude(params) do
          {:ok, struct} -> struct
          {:error, _, errors} -> raise "Error extruding #{inspect(errors)}"
        end
      end

      def fields_list do
        @__extruder__.fields
      end
    end
  end

end
