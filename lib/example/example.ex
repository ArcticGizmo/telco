defmodule Telco.Example do
  use GenServer

  @type station :: atom()
  @type topic :: tuple() | String.t()
  @type message :: any()

  alias Telco.Logger

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_args) do
    state = %{
      sent: [],
      received: []
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_messages, _from, state) do
    {:reply, {state.sent, state.received}, state}
  end

  def handle_call({:subscribe, topic}, _from, state) do
    resp = Telco.subscribe(topic)
    case resp do
      :ok -> Logger.info("sub", "#{topic} | :ok")
      {:error, reason} -> Logger.error("sub", "#{topic} | error: #{inspect(reason)}")
    end

    {:reply, resp, state}
  end

  def handle_call({:broadcast, topic, message}, _from, state) do
    resp = Telco.broadcast(topic, message)

    case resp do
      :ok -> Logger.info("out", "#{topic} | sent: #{inspect(message)}")
      {:error, reason} -> Logger.info("out", "#{topic} | error: #{inspect(reason)}")
    end

    messages = add_message(state.sent, message, resp)
    new_state = Map.put(state, :sent, messages)

    {:reply, resp, new_state}
  end

  def handle_info({topic, message}, state) do
    Logger.info("in", "#{topic} | got: #{inspect(message)}")
    messages = add_message(state.received, {topic, message})
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

  @spec subscribe(topic) :: :ok | {:error, :no_station | term}
  def subscribe(topic) do
    GenServer.call(__MODULE__, {:subscribe, topic})
  end

  @spec broadcast(topic, message) :: :ok | {:error, :no_station | term}
  def broadcast(topic, message) do
    GenServer.call(__MODULE__, {:broadcast, topic, message})
  end
end
