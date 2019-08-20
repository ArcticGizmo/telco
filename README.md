# Telco

Telco is an extension of Phoenix.PubSub to allow the simple broadcasting and listening
  across connected nodes

## Stations
Stations are the way that broadcasting towers identify themselves
{tower_id, topic, subtopic}

## Broadcasting


## Transmit
Transmit is the process by which a message is sent to a connected node and a response
  is required.

## Listening
Listening allows a node to listen to a 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `telco` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:telco, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/telco](https://hexdocs.pm/telco).

