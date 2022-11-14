defmodule CryptoBot.Gecko do
  @moduledoc """
  This module is used for making API requests to coingecko platform for getting crypto data.
  """
  @gecko_search_url "https://api.coingecko.com/api/v3/search"

  @doc """
  Search coins based on coin name or ID using coingecko search API.
  """

  @spec search_coin(String.t()) :: list()
  def search_coin(coin) do
    search_url = @gecko_search_url <> "?query=#{coin}"

    case HTTPoison.get(search_url) do
      {:ok, response} ->
        coins = Jason.decode!(response.body)["coins"]
        Enum.take(coins, 5)

      {:error, reason} ->
        IO.inspect(reason)
        []
    end
  end

  @doc """
  Fetch USD price for a coin using coin id from coingecko market chart data
  """

  @spec fetch_usd_price(String.t()) :: list()
  def(fetch_usd_price(coin_id)) do
    market_chart_url =
      "https://api.coingecko.com/api/v3/coins/#{coin_id}/market_chart?vs_currency=usd&days=14&interval=daily"

    case HTTPoison.get(market_chart_url) do
      {:ok, response} ->
        Jason.decode!(response.body)["prices"]
        |> Enum.take(14)

      {:error, reason} ->
        IO.inspect(reason)
        []
    end
  end
end
