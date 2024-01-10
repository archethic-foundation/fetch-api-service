import Config

config :archethic_fas, ArchethicFAS.Quotes.Provider.CoinMarketCap,
  key: System.fetch_env!("ARCHETHIC_PRICE_API_KEY"),
  endpoint: "pro-api.coinmarketcap.com"
