defmodule Telco.Application do
  @moduledoc """
  Telco allows the broadcasting of messages across connected
    nodes
  """

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub.PG2, name: Telco.station()},
    ]

    opts = [strategy: :one_for_one, name: TrackPub.PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc false
  def start_example() do
    Supervisor.start_child(TrackPub.PubSub.Supervisor, Telco.Example)
  end
end
