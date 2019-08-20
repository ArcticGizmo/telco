defmodule Telco.Listener do
  @moduledoc """
  Telco listener allows users to listen in on broadcasters over connected nodes
  """

  @type broadcast_id :: tuple | String.t()

  alias Phoenix.PubSub
  alias Telco.Logger

  @spec subscribe(atom, broadcast_id) :: :ok | {:error, any}
  def subscribe(server \\ Telco.tower_name(), broadcast_id) do
    topic = Telco.Broadcaster.broadcast_to_string(broadcast_id)
    Logger.info("listener", "Subscribed to '#{topic}'")
    PubSub.subscribe(server, topic)
  end

  @spec subscribe_all(atom, list(broadcast_id)) :: :ok | {:error, list(term)}
  def subscribe_all(server \\ Telco.tower_name(), broadcast_ids) do
    Enum.map(broadcast_ids, &subscribe(server, &1))
    |> Enum.reduce([], fn return, acc ->
      case return do
        :ok -> acc
        {:error, reason} -> [reason | acc]
      end
    end)
    |> case do
      [] -> :ok
      reasons -> {:error, reasons}
    end
  end
end
