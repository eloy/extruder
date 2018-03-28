defmodule FieldFloatSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :float
    end
  end

  it "should accept numbers" do
    {:ok, model} = TestModel.extrude %{foo: 1.9}
    expect(model.foo) |> to(eq(1.9))
  end

  it "should convert numbers from strings" do
    {:ok, model} = TestModel.extrude %{foo: "1.9"}
    expect(model.foo) |> to(eq(1.9))
  end


  it "should raise errors converting invalid numbers" do
    {:error, s, errors} = TestModel.extrude %{foo: "not a number"}
    expect(errors) |> to(eq(%{foo: [:is_not_a_number]}))
  end


end
