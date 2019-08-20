import Config

config :telco,
  logger: :all,
  tower: :telco_tower

config :liaison,
  strategies: [
    [
      strategy: Liaison.Strategy.Epmd,
      # nodes: ["a", "b"]
    ]
  ]
