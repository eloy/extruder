defmodule ValidatesInclussionSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :atom

    end
  end
end
