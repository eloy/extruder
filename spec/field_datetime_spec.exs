defmodule FieldDatetimeSpec do
  use ESpec


  defmodule DatetimeModel do
    use Extruder

    defmodel do
      field :foo, :datetime
    end
  end

  it "should build datetime from string" do
    {:ok, model} = DatetimeModel.extrude %{foo: "2017-11-18 09:44:04.378518Z"}
    expect(model.foo) |> to(eq(Timex.parse!("2017-11-18 09:44:04.378518Z", "{ISO:Extended:Z}")))
  end

  it "should return the date if pass a date" do
    date = Timex.now
    {:ok, model} = DatetimeModel.extrude %{foo: date}
    expect(model.foo) |> to(eq(date))
  end

  it "should return errors with invalid dates" do
    {:error, model, errors} = DatetimeModel.extrude %{foo: "foo"}
    expect(errors) |> to(eq(%{foo: ["Invalid date"]}))
  end

    it "should return nil if we pass nil" do
    {:ok, model} = DatetimeModel.extrude %{foo: nil}
    expect(model.foo) |> to(eq(nil))

    {:ok, model} = DatetimeModel.extrude %{foo: ""}
    expect(model.foo) |> to(eq(nil))
  end

end
