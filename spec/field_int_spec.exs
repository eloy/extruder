defmodule FieldIntSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :int
    end
  end

  it "should accept numbers" do
    {:ok, model} = TestModel.extrude %{foo: 1}
    expect(model.foo) |> to(eq(1))
  end

  it "should convert numbers from strings" do
    {:ok, model} = TestModel.extrude %{foo: "1"}
    expect(model.foo) |> to(eq(1))
  end


  it "should accept empty strings as nil" do
    {:ok, model} = TestModel.extrude %{foo: ""}
    expect(model.foo) |> to(be_nil)
  end

  it "should accept nil" do
    {:ok, model} = TestModel.extrude %{foo: nil}
    expect(model.foo) |> to(be_nil)
  end


  it "should raise errors converting invalid numbers" do
    {:error, s, errors} = TestModel.extrude %{foo: "not a number"}
    expect(errors) |> to(eq(%{foo: [:is_not_a_number]}))
  end


end
