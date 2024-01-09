import Config

config :archethic_price, ArchethicPrice.Provider.CoinMarketCap,
  interval: 60_000,
  key: System.fetch_env!("ARCHETHIC_PRICE_API_KEY"),
  endpoint: "pro-api.coinmarketcap.com"
