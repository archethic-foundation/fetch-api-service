import Config

IO.puts("==========================")
IO.puts("== RUNNING IN PROD MODE ==")
IO.puts("==========================")

config :archethic_fas, ArchethicFAS.QuotesLatest.Provider.CoinMarketCap,
  endpoint: "pro-api.coinmarketcap.com"
