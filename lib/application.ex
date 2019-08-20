defmodule Telco.Application do
  @moduledoc """
  Telco allows the broadcasting of messages across connected
    nodes
  """

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub.PG2, name: Telco.tower_name()},
      Telco.Example
    ]

    opts = [strategy: :one_for_one, name: TrackPub.PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
