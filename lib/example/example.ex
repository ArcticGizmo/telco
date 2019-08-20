defmodule Telco.Example do

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    Telco.Listener.subscribe_all(["apple", "banana"])
    {:ok, state}
  end

  def handle_info({topic, message}, state) do
    IO.puts("On topic: #{topic}")
    IO.inspect(inspect(message))
    {:noreply, state}
  end
end
