import Config

config :telco,
  logger: :all,
  tower: :telco_tower

import_config("#{Mix.env()}.exs")
