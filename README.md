# Extruder

Extruder let you build and validate structs from any source.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

Add extruder to your list of dependencies in `mix.exs`:

    def deps do
      [{:extruder, "~> 0.0.1"}]
    end


## Usage
    defmodule TestModel do
      use Extruder
  
      defmodel do
        field :foo, :int
        field :bar, :int, default: 1
        field :bool_def, :boolean
        field :def_str, :string
        field :text, :string, default: "foo bar wadus"
        field :list_def, :list
        field :map_def, :map, default: %{foo: []}
      end
    end
