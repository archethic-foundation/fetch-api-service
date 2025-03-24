import Config

# The Unified Cryptoasset ID (UCID) assigns a unique ID to each cryptoasset
# to minimize any confusion that may arise from assets that share identical tickers/symbols.
config :archethic_fas,
  api_port: 3000,
  coins: [
    %{
      ucid: 1,
      coingecko: "bitcoin",
      archethic: "00002CEC79D588D5CDD24331968BEF0A9CFE8B1B03B8AEFC4454726DEF79AA10C125"
    },
    %{
      ucid: 825,
      coingecko: "tether",
      archethic: nil
    },
    %{
      ucid: 1027,
      coingecko: "ethereum",
      archethic: "0000457EACA7FBAA96DB4A8D506A0B69684F546166FBF3C55391B1461907EFA58EAF"
    },
    %{
      ucid: 1839,
      coingecko: "binancecoin",
      archethic: nil
    },
    %{
      ucid: 3408,
      coingecko: "usd-coin",
      archethic: nil
    },
    %{
      ucid: 3890,
      replaced_by: 28321,
      coingecko: "pol-ex-matic",
      archethic: nil
    },
    %{
      ucid: 28321,
      coingecko: "polygon",
      archethic: nil
    },
    %{
      ucid: 6887,
      coingecko: "archethic",
      archethic: "UCO"
    },
    %{
      ucid: 20920,
      coingecko: "monerium-eur-money",
      archethic: "00005751A05BA007E7E2518DEA171DBBD67B0527C637232F923830C39BFF9E8F159A"
    }
  ]

config :archethic_fas, ArchethicFAS.AESwap,
  router_address: "000077CEC9D9DBC0183CAF843CBB4828A932BB1457E382AC83B31AD6F9755DD50FFC"

config :archethic_fas, ArchethicFAS.ArchethicApi, endpoint: "mainnet.archethic.net"

config :archethic_fas, ArchethicFAS.QuotesLatest.Scheduler, schedule_interval: :timer.minutes(5)

import_config("#{Mix.env()}.exs")
