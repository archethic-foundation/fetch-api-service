defmodule ArchethicPrice.Provider.CoinMarketCapTest do
  @moduledoc """
  These tests are running on the sandbox-api from CMC.
  Real HTTP queries are done.
  """
  use ExUnit.Case
  alias ArchethicPrice.Provider.CoinMarketCap

  describe "get_current/1" do
    test "empty list of currency should return a valid empty response" do
      assert {:ok, %{}} = CoinMarketCap.get_current([])
    end

    test "invalid currency should return an error" do
      assert {:error, :invalid_currency} = CoinMarketCap.get_current([:unknown])
      assert {:error, :invalid_currency} = CoinMarketCap.get_current([:unknown, :eth, :bitcoin])
    end

    test "valid currency should return a valid response" do
      assert {:ok, map} = CoinMarketCap.get_current([:eth])
      assert [:eth] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:matic])
      assert [:matic] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:bitcoin])
      assert [:bitcoin] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:bnb])
      assert [:bnb] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:uco])
      assert [:uco] = Map.keys(map)
      assert Enum.all?(Map.values(map), &is_float/1)
      assert {:ok, map} = CoinMarketCap.get_current([:eth, :matic, :bitcoin, :bnb, :uco])
      assert Enum.all?(Map.keys(map), &ArchethicPrice.valid_currency/1)
      assert Enum.all?(Map.values(map), &is_float/1)
    end
  end
end
