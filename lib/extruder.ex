defmodule Extruder do

  defmacro __using__(_opts) do
    quote do
      import Extruder
      @fields []
    end
  end


  defmacro defmodel(block) do
    quote do
      import Extruder.Fields
      # Parse the fields
      unquote(block)

      # Build the struct
      defstruct struct_def(@fields)

      # add some helpers
      def extrude(params) do
        struct = %__MODULE__{}
        {struct, errors} = Extruder.Builder.sanitize(struct, @fields, params)
        case errors do
          [] -> {:ok, struct}
          errors -> {:error, errors}
        end
      end
    end
  end

end
