defmodule FieldStructsListSpec do
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
      field :foo, :structs_list, module: NeestedStruct
    end
  end

  it "should build structs list" do
    {:ok, model} = TestModel.extrude %{foo: [%{"bar" => 1}]}
    [neested] = model.foo
    expect(neested.bar) |> to(eq(1))
  end


  it "should raise errors converting invalid structs" do
    {:error, s, errors} = TestModel.extrude %{foo: "not a list"}
    expect(errors) |> to(eq([foo: [:is_not_a_list]]))
  end

  it "should include neested errors" do
    {:error, s, errors} = TestModel.extrude %{foo: [%{}]}
    expect(errors) |> to(eq([foo: [{0, [bar: [:can_not_be_nil]]}]]))
  end

end
