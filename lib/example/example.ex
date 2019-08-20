defmodule Telco.Example do

  use GenServer

  # want to make a useing statement that says what you wil be subscribed to
  # at copile time

  def start_link(_args) do
    # name will not be __MODULE__ in the long run because it needs to work with
    # anyones genserver
    # this means that it will be like Agent
    # I might want to make state that holds information about subscriptions
    #   though this might be attainable through PG2
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    # what to subscribe to will go here I think
    Phoenix.PubSub.subscribe(Telco.tower_name(), "eggplant:cheese")
    {:ok, state}
  end

  def handle_info(stuff, state) do
    # IO.puts("On topic: #{topic}")
    # IO.inspect(inspect(msg))
    IO.inspect(stuff)
    {:noreply, state}
  end
end
