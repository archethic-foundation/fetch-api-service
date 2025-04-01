import Config

if config_env() == :prod do
  config :archethic_fas, ArchethicFAS.QuotesLatest.Provider.CoinMarketCap,
    key: System.get_env("ARCHETHIC_CMC_PRO_API_KEY")

  config :archethic_fas, ArchethicFAS.QuotesHistorical.Provider.Coingecko,
    key: System.get_env("ARCHETHIC_COINGECKO_API_KEY")

  config :archethic_fas,
    api_port: System.get_env("ARCHETHIC_FAS_PORT", "3000") |> String.to_integer()
end
