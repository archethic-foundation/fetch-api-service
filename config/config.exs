import Config

# The Unified Cryptoasset ID (UCID) assigns a unique ID to each cryptoasset
# to minimize any confusion that may arise from assets that share identical tickers/symbols.
config :archethic_fas,
  api_port: 3000,
  ucids: %{
    uco: 6887,
    matic: 3890,
    bnb: 1839,
    bitcoin: 1,
    eth: 1027
  }

import_config("#{Mix.env()}.exs")
