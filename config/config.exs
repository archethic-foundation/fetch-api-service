import Config

# The Unified Cryptoasset ID (UCID) assigns a unique ID to each cryptoasset
# to minimize any confusion that may arise from assets that share identical tickers/symbols.
config :archethic_fas,
  api_port: 3000,
  genesis_pools: %{
    "0000E0EF0C5A8242D7F743E452E3089B7ACAC43763A3F18C8F5DD38D22299B61CE0E" =>
      381_966_011 * 100_000_000,
    "000047C827E93C4F1106906D3F43546EB09176F03DFF15275759D47BF33D9B0D168A" =>
      236_067_977 * 100_000_000,
    "000012023D76D65F4A20E563682522576963E36789897312CB6623FDF7914B60ECEF" =>
      145_898_033 * 100_000_000,
    "00004769C94199BCA872FFAFA7CE912F6DE4DD8B2B1F4A41985CD25F3C4A190C72BB" =>
      90_169_943 * 100_000_000,
    "0000DBE5D04070411325BA8254BC0CE005DF30EBFDFEEFADBC6659FA3D5FA3263DFD" =>
      55_728_090 * 100_000_000,
    "0000BB90E7EC3051BF7BE8D2BF766DA8BED88AFA696D282ACF5FF8479CE787397E16" =>
      34_441_857 * 100_000_000,
    "000050CEEE9CEEB411FA027F1FB9247FE04297FF00358D87DE4B7B8F2A7051DF47F7" =>
      21_286_236 * 100_000_000
  },
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
      coingecko: "matic-network",
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
