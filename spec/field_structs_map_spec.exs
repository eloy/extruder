defmodule FieldStructsMapSpec do
  use ESpec

  defmodule NeestedStruct do
    use Extruder
    defmodel do
      field :bar, :int
      validates_presence_of :bar
    end

  end

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :structs_map, module: NeestedStruct
    end
  end

  it "should build structs list" do
    {:ok, model} = TestModel.extrude %{foo: %{"a" => %{"bar" => 1}}}
    %{"a" => neested} = model.foo
    expect(neested.bar) |> to(eq(1))
  end


  it "should raise errors converting invalid structs" do
    {:error, s, errors} = TestModel.extrude %{foo: "not a map"}
    expect(errors) |> to(eq(%{foo: [:is_not_a_map]}))
  end

  it "should include neested errors" do
    {:error, s, errors} = TestModel.extrude %{foo: %{"a" => %{}}}
    expect(errors) |> to(eq(%{foo: %{"a" => %{bar: [:can_not_be_nil]}}}))
  end

end
