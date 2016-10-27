defmodule ExampleStruct do
  defstruct a: 'b'
end

defmodule Appsignal.Utils.ParamsEncoderTest do
  use ExUnit.Case

  alias Appsignal.Utils.ParamsEncoder

  describe "paremeter preprocessing" do
    test "converts keys into strings" do
      assert %{"foo" => "bar"} == ParamsEncoder.preprocess(%{"foo" => "bar"})
      assert %{"1" => "bar"} == ParamsEncoder.preprocess(%{1 => "bar"})
      assert %{"{:weird, :key}" => "bar"} == ParamsEncoder.preprocess(%{{:weird, :key} => "bar"})
    end

    test "does not convert atom keys into strings" do
      assert %{:foo => "bar"} == ParamsEncoder.preprocess(%{:foo => "bar"})
    end

    test "handles keys in deeply nested values" do
        assert %{"1" => [%{"2" => true}]} == ParamsEncoder.preprocess(%{1 => [%{2 => true}]})
    end

    test "handles list values" do
      assert "{:bar, :baz}" ==
        ParamsEncoder.preprocess({:bar, :baz})
    end

    test "handles tuple values" do
      assert "{:bar, :baz}" ==
        ParamsEncoder.preprocess({:bar, :baz})
    end

    test "handles nested tuple values" do
      assert %{"tuple" => "{:bar, :baz}"} ==
        ParamsEncoder.preprocess(%{"tuple" => {:bar, :baz}})
    end

    test "handles struct values" do
      assert %{:a => "b"} == ParamsEncoder.preprocess(%ExampleStruct{})
    end

    test "handles nested struct values" do
      assert %{struct: %{:a => "b"}} == ParamsEncoder.preprocess(
       %{struct: %ExampleStruct{}}
     )
    end

    test "handles nil values" do
      assert nil == ParamsEncoder.preprocess(nil)
    end
  end
end
