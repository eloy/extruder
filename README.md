# Extruder

Extruder let you build and validate structs from any source.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

Add extruder to your list of dependencies in `mix.exs`:

    def deps do
      [{:extruder, "~> 0.0.1"}]
    end


## Usage
### Describe your model
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
        field :some_atom, :atom
        field :neested_struct, :struct, module: MyApp.NeestedStruct
        field :neested_struct_list, :structs_list, module: MyApp.NeestedStruct
        
        validates_presence_of :foo
      end
    end
### Create structs from any source
    
    iex> TestModel.extrude %{"foo" => 1}
    {:ok,
     %TestModel{bar: 1, bool_def: false, def_str: nil, foo: 1, list_def: [],
      map_def: %{foo: []}, neested_struct: nil, neested_struct_list: nil,
      some_atom: nil, text: "foo bar wadus"}}

    iex> TestModel.extrude %{"bar" => 2}
    {:error,
     %TestModel{bar: 2, bool_def: false, def_str: nil, foo: nil, list_def: [],
      map_def: %{foo: []}, neested_struct: nil, neested_struct_list: nil,
      some_atom: nil, text: "foo bar wadus"}, [foo: [:can_not_be_nil]]}
