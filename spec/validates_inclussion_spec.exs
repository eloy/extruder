defmodule ValidatesInclussionSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :atom
      validates_inclussion_of :foo, in: [:a, :b]
    end
  end

  it "should include atoms in the list" do
    {:ok, model} = TestModel.extrude %{foo: "a"}
    expect(model.foo) |> to(eq(:a))
  end

  it "should raise errors if the atom is not in the list" do
    {:error, s, errors} = TestModel.extrude %{foo: "ok"}
    expect(errors) |> to(eq([foo: [:is_not_permitted]]))
  end
end
