defmodule FieldStructSpec do
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
      field :foo, :struct, module: NeestedStruct
    end
  end

  it "should build struct" do
    {:ok, model} = TestModel.extrude %{foo: %{"bar" => 1}}
    expect(model.foo.bar) |> to(eq(1))
  end


  it "should raise errors converting invalid structs" do
    {:error, s, errors} = TestModel.extrude %{foo: "not a number"}
    expect(errors) |> to(eq([foo: [:is_not_an_struct]]))
  end

  it "should include neested errors" do
    {:error, s, errors} = TestModel.extrude %{foo: %{}}
    expect(errors) |> to(eq([foo: [bar: [:can_not_be_nil]]]))
  end

end
