import Config

IO.puts("==========================")
IO.puts("== RUNNING IN PROD MODE ==")
IO.puts("==========================")

config :archethic_fas, ArchethicFAS.Quotes.Provider.CoinMarketCap,
  key: System.get_env("ARCHETHIC_CMC_PRO_API_KEY"),
  endpoint: "pro-api.coinmarketcap.com"
