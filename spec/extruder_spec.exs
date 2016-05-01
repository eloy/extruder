defmodule ExampleSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :int
      field :bar, :int, default: 1
      field :bool_def, :boolean
      field :bool_true, :boolean, default: true
      field :bool_false, :boolean, default: false
      field :def_str, :string
      field :text, :string, default: "foo bar wadus"
      field :list_def, :list
      field :map_def, :map
    end
  end

  describe "Initializer" do
    it "should initialize fields" do
      t = %TestModel{}
      expect t.foo |> to(eq(0))
      expect t.bar |> to(eq(1))
      expect(t.bool_def) |> to(be_false)
      expect(t.bool_true) |> to(be_true)
      expect(t.bool_false) |> to(be_false)
      expect(t.list_def) |> to(eq([]))
      expect(t.map_def) |> to(eq(%{}))
    end
  end

  describe "extrude" do
    it "should initialize a new struct" do
      {:ok, s} = TestModel.extrude %{"foo" => 2, list_def: [1, 2, 3]}
      expect(s) |> to(eq(%TestModel{foo: 2, list_def: [1,2,3]}))
    end

    it "should ignore invalid fields" do
      {:ok, s} = TestModel.extrude %{"foo" => 2, "invalid" => "ignore me"}
      expect(s) |> to(eq(%TestModel{foo: 2}))
    end

  end
end