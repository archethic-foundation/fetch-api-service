import Config

config :archethic_fas, ArchethicFAS.Provider.CoinMarketCap,
  interval: 100,
  key: "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c",
  endpoint: "sandbox-api.coinmarketcap.com",
  transport_opts: [verify: :verify_none]
