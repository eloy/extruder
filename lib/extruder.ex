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
    end
  end
end
