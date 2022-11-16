defmodule CryptoBot.GeckoTest do
  use ExUnit.Case

  alias CryptoBot.Gecko
  @coin_name "Ethereum"
  @coin_id "bitcoin"

  # setup do
  #   bypass = Bypass.open()
  #   {:ok, bypass: bypass}
  # end

  def search_coin_fixture_using_name do
    Gecko.search_coin(@coin_name)
  end

  def fetch_price_fixture do
    Gecko.fetch_usd_price(@coin_id)
  end

  def search_coin_fixture_using_id do
    Gecko.search_coin(@coin_id)
  end

  describe "Search coin API from Coingecko API using name" do
    test "search coin using name" do
      assert length(search_coin_fixture_using_name()) > 0
    end
  end

  describe "Search coin API from Coingecko API using ID" do
    test "search coin using Coin ID" do
      assert length(search_coin_fixture_using_id()) > 0
    end
  end

  describe "Fetch USD price from coingecko using coinID" do
    test "fetch USD price using Coin ID" do
      assert length(fetch_price_fixture()) > 0
    end
  end
end
