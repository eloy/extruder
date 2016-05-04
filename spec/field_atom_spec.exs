defmodule FieldAtomrSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :atom
    end
  end

  it "should convert valid atoms" do
    {:ok, model} = TestModel.extrude %{foo: "ok"}
    expect(model.foo) |> to(eq(:ok))
  end

  it "should raise errors converting invalid atoms" do
    {:error, s, errors} = TestModel.extrude %{foo: "will_never_exists"}
    expect(errors) |> to(eq([foo: [:is_not_an_existing_atom]]))
  end


end
