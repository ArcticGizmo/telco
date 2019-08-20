defmodule Telco.Broadcaster do
  @moduledoc """
  Handles all broadcasting
  """
  @type broadcast_id :: tuple | String.t()
  @type message :: any()

  @doc """
  Broadcasts the provided `message` over the `server` with topic `broadcast_id`

  Handle info is of the format `{broadcast_id, message}`
  """

  @spec broadcast(atom(), broadcast_id, message) :: :ok | {:error, term}
  def broadcast(server \\ Telco.tower_name(), broadcast_id, message) do
    topic = broadcast_to_string(broadcast_id)
    Phoenix.PubSub.broadcast(server, topic, {broadcast_id, message})
  end

  def broadcast_to_string(broadcast_id) when is_binary(broadcast_id) do
    broadcast_id
  end

  def broadcast_to_string(broadcast_id) when is_tuple(broadcast_id) do
    broadcast_id
    |> Tuple.to_list()
    |> Enum.join(":")
  end
end
