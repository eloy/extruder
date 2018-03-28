defmodule ValidatesInclussionSpec do
  use ESpec

  defmodule TestModel do
    use Extruder

    defmodel do
      field :foo, :atom

      validates :foo, :test_validation

      def test_validation(:foo, model, _opt) do
        case model.foo do
          :a -> :ok
          _ -> {:error, :is_not_a}
        end
      end
    end
  end


  it "should run custom validations" do
    {:ok, model} = TestModel.extrude %{foo: "a"}
    expect(model.foo) |> to(eq(:a))
  end

  it "should run custom validations" do
    {:error, _model, errors} = TestModel.extrude %{foo: "error"}
    expect(errors) |> to(eq(%{foo: [:is_not_a]}))
  end

end
