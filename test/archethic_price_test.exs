defmodule ArchethicPriceTest do
  use ExUnit.Case
  doctest ArchethicPrice

  describe "valid_currency/1" do
    test "should return true for accepted currencies" do
      assert ArchethicPrice.valid_currency(:eth)
      assert ArchethicPrice.valid_currency(:bnb)
      assert ArchethicPrice.valid_currency(:matic)
      assert ArchethicPrice.valid_currency(:bitcoin)
      assert ArchethicPrice.valid_currency(:uco)
    end

    test "should return false  for anything else" do
      refute ArchethicPrice.valid_currency(:unknown)
    end
  end

  describe "valid_currencies/1" do
    test "should return true for accepted currencies" do
      assert ArchethicPrice.valid_currencies([])
      assert ArchethicPrice.valid_currencies([:eth])
      assert ArchethicPrice.valid_currencies([:eth, :bnb])
      assert ArchethicPrice.valid_currencies([:eth, :bnb, :matic, :bitcoin, :uco])
    end

    test "should return false when a currency is not accepted" do
      refute ArchethicPrice.valid_currencies([:unknown])
      refute ArchethicPrice.valid_currencies([:eth, :bnb, :unknown])
      refute ArchethicPrice.valid_currencies([:eth, :bnb, :matic, :unknown, :bitcoin, :uco])
    end
  end
end
