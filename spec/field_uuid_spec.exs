defmodule FieldUUIDSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :uuid
    end
  end

  it "should accept strings" do
    {:ok, model} = TestModel.extrude %{foo: "61c2f002-a7da-4785-b7eb-0374d003b218"}
    expect(model.foo) |> to(eq("61c2f002-a7da-4785-b7eb-0374d003b218"))
  end


  it "should raise errors converting invalid values" do
    {:error, s, errors} = TestModel.extrude %{foo: 1}
    expect(errors) |> to(eq(%{foo: [:is_not_a_UUID]}))
  end


end
