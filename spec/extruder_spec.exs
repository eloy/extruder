defmodule ExampleSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :int
      field :bar, :int, default: 5
      field :bool_def, :boolean
      field :bool_true, :boolean, default: true
      field :bool_false, :boolean, default: false
      field :def_str, :string
      field :text, :string, default: "foo bar wadus"
      field :list_def, :list
      field :map_def, :map
      field :my_map, :map, default: %{foo: []}

      validates_presence_of :foo
    end
  end

  describe "Initializer" do
    it "should initialize fields" do
      t = %TestModel{foo: 1}
      expect t.foo |> to(eq(1))
      expect t.bar |> to(eq(5))
      expect(t.bool_def) |> to(be_false)
      expect(t.bool_true) |> to(be_true)
      expect(t.bool_false) |> to(be_false)
      expect(t.list_def) |> to(eq([]))
      expect(t.map_def) |> to(eq(%{}))
      expect(t.my_map) |> to(eq(%{foo: []}))
    end
  end

  describe "extrude" do
    it "should set fields" do
      {:ok, s} = TestModel.extrude %{"foo" => 2, list_def: [1, 2, 3]}
      expect(s) |> to(eq(%TestModel{foo: 2, list_def: [1,2,3]}))
    end

    it "should ignore invalid fields" do
      {:ok, s} = TestModel.extrude %{"foo" => 2, "invalid" => "ignore me"}
      expect(s) |> to(eq(%TestModel{foo: 2}))
    end

    it "should check validations" do
      {:error, s, errors} = TestModel.extrude %{}
    end

  end
end
