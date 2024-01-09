defmodule ArchethicFAS.CurrencyTest do
  alias ArchethicFAS.Currency

  use ExUnit.Case
  doctest ArchethicFAS

  describe "cast/1" do
    test "should return ok for known currencies" do
      assert {:ok, :eth} = Currency.cast("eth")
      assert {:ok, :bnb} = Currency.cast("bnb")
      assert {:ok, :matic} = Currency.cast("matic")
      assert {:ok, :bitcoin} = Currency.cast("bitcoin")
      assert {:ok, :uco} = Currency.cast("uco")
    end

    test "should return error  for anything else" do
      assert :error = Currency.cast("unknown")
    end
  end

  describe "cast_many/1" do
    test "should return ok for known currencies" do
      assert {:ok, [:bnb, :eth]} = Currency.cast_many(["eth", "bnb"])
    end

    test "should return error  for anything else" do
      assert {:error, {:invalid_currency, "unknown"}} =
               Currency.cast_many(["eth", "unknown", "bnb"])
    end
  end
end
