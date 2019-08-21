import Config

config :liaison,
  strategies: [
    [
      strategy: Liaison.Strategy.Epmd,
      # nodes: ["a", "b"]
    ]
  ]
