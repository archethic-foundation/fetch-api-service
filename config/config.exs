import Config

# The Unified Cryptoasset ID (UCID) assigns a unique ID to each cryptoasset
# to minimize any confusion that may arise from assets that share identical tickers/symbols.
config :archethic_fas,
  api_port: 3000,
  ucids: [
    # uco
    6887,
    # matic
    3890,
    # bnb
    1839,
    # btc
    1,
    # eth
    1027,
    # usdc
    3408,
    # monerium eure
    20920,
    # usdt
    825,
    # bnb
    1839
  ]

config :archethic_fas, ArchethicFAS.QuotesLatest.Scheduler, schedule_interval: :timer.minutes(5)

config :archethic_fas, ArchethicFAS.QuotesHistorical.Scheduler,
  schedule_interval: :timer.minutes(1)

import_config("#{Mix.env()}.exs")
