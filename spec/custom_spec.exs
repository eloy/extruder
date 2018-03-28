defmodule FieldCustomSpec do
  use ESpec

  defmodule TestModel do
    use Extruder
    def parse_foo(value) do
      if is_integer(value) do
        {:ok, value + 1}
      else
        {:error, :is_not_a_number}
      end
    end

    defmodel do
      field :foo, :custom, parse: &TestModel.parse_foo(&1)
    end
  end

  it "should convert valid customs" do
    {:ok, model} = TestModel.extrude %{foo: 1}
    expect(model.foo) |> to(eq(2))
  end

  it "should raise errors converting invalid customs" do
    {:error, s, errors} = TestModel.extrude %{foo: "will_not_work"}
    expect(errors) |> to(eq(%{foo: [:is_not_a_number]}))
  end
end
