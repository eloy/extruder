defmodule Extruder do

  defmacro __using__(_opts) do
    quote do
      import Extruder
      @__extruder__ %{validations: [], fields: []}
    end
  end


  defmacro defmodel(block) do
    quote do
      import Extruder.Fields
      import Extruder.ValidationHelpers

      # Parse the fields
      unquote(block)

      # Build the struct
      defstruct struct_def(@__extruder__.fields)

      # add some helpers
      def extrude(params) do
        struct = %__MODULE__{}
        {struct, errors} = Extruder.Builder.sanitize(@__extruder__, struct, params)
        case errors do
          [] -> {:ok, struct}
          errors -> {:error, struct, errors}
        end
      end
    end
  end

end
