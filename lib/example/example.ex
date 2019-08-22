defmodule Telco.Example do
  use GenServer

  alias Telco.Broadcaster
  alias Telco.Listener
  alias Telco.Logger

  def start_link(_args) do
    state = %{
      sent: [],
      received: []
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    # Telco.Listener.subscribe_all(["apple", "banana"])
    {:ok, state}
  end

  def handle_call(:get_messages, _from, state) do
    {:reply, {state.sent, state.received}, state}
  end

  def handle_call({:subscribe, broadcast_id}, _from, state) do
    resp = Listener.subscribe(broadcast_id)
    {:reply, resp, state}
  end

  def handle_call({:broadcast, broadcast_id, message}, _from, state) do
    Logger.info("broadcaster", "on: `#{broadcast_id}` => `#{inspect(message)}`")
    resp = Broadcaster.broadcast(broadcast_id, message)

    messages = add_message(state.sent, message, resp)
    new_state = Map.put(state, :sent, messages)

    {:reply, resp, new_state}
  end

  def handle_info({broadcast_id, message}, state) do
    Logger.info("listener", "on: `#{broadcast_id}` => `#{inspect(message)}`")
    messages = add_message(state.received, {broadcast_id, message})
    new_state = Map.put(state, :received, messages)

    {:noreply, new_state}
  end

  # -------------- helpers -----------------
  defp add_message(messages, new_message) do
    [new_message | Enum.take(messages, 4)]
  end

  defp add_message(messages, new_message, status) do
    stati =
      case status do
        :ok -> :ok
        {:error, _reason} -> :error
      end

    add_message(messages, {stati, new_message})
  end

  # ---------------- client calls -----------------
  def get_messages() do
    GenServer.call(__MODULE__, :get_messages)
  end

  def subscribe(broadcast_id) do
    GenServer.call(__MODULE__, {:subscribe, broadcast_id})
  end

  def broadcast(broadcast_id, message) do
    GenServer.call(__MODULE__, {:broadcast, broadcast_id, message})
  end
end
