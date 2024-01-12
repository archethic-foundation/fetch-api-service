import Config

config :archethic_fas, [
  api_port: System.get_env("ARCHETHIC_FAS_PORT", "3000") |> String.to_integer()
]
