defmodule Telco do
  @type station :: atom()
  @type topic :: tuple() | String.t()
  @type message :: any()

  alias Phoenix.PubSub

  # ------------------------------- helper ----------------------
  @spec stations() :: list[station]
  def stations() do
    Application.get_env(:telco, :stations, [:telco])
  end

  @spec station() :: station
  def station() do
    List.first(stations())
  end

  @spec topic_as_string(any) :: String.t()
  def topic_as_string(topic) when is_binary(topic), do: topic

  def topic_as_string(topic) do
    topic
    |> Tuple.to_list()
    |> Enum.join(":")
  end

  @spec topic_as_components(any) :: tuple()
  def topic_as_components(topic) when is_tuple(topic), do: topic

  def topic_as_components(topic) do
    topic
    |> String.split(":")
    |> List.to_tuple()
  end

  defp handle_errors(responses) do
    case responses do
      [] -> :ok
      errors -> {:error, Enum.map(errors, &elem(&1, 1))}
    end
  end

  # --------------------------- broadcasting ---------------------
  @doc """
  The same as broadcast/3 where the stations is the first configured station
  """
  @spec broadcast(topic, message) :: :ok | {:error, term}
  def broadcast(topic, message) do
    broadcast(Telco.station(), topic, message)
  end

  @doc """
  Broadcast to all nodes connected to `station` on `topic` with the given
  `message`
  """
  @spec broadcast(station, topic, message) :: :ok | {:error, term}
  def broadcast(nil, _topic, _message), do: {:error, :no_station}

  def broadcast(station, topic, message) do
    topic_str = topic_as_string(topic)
    PubSub.broadcast(station, topic_str, {topic, message})
  end

  @doc """
  Broadcasts over all configured stations
  """
  @spec broadcast_all(topic, message) :: :ok | {:error, :no_station | list(term)}
  def broadcast_all(topic, message) do
    broadcast_all(Telco.stations(), topic, message)
  end

  @doc """
  Broadcast the given `message` on `topic` for every configured server
  """
  @spec broadcast_all(list(station), topic, message) :: :ok | {:error, :no_station | list(term)}
  def broadcast_all(nil, _topic, _message), do: {:error, :no_station}

  def broadcast_all(stations, topic, message) do
    stations
    |> Enum.map(&broadcast(&1, topic, message))
    |> Enum.reject(&(&1 == :ok))
    |> handle_errors()
  end

  # ---------------------------- subscribing -------------------------
  @spec subscribe(topic) :: :ok | {:error, term}
  def subscribe(topic) do
    subscribe(Telco.station(), topic)
  end

  @spec subscribe(station, topic) :: :ok | {:error, any}
  def subscribe(nil, _topic), do: {:error, :no_station}

  def subscribe(station, topic) do
    topic_str = topic_as_string(topic)
    PubSub.subscribe(station, topic_str)
  end

  @spec subscribe_all(topic) :: :ok | {:error, :no_station | list(term)}
  def subscribe_all(topic) do
    subscribe(Telco.stations(), topic)
  end

  @spec subscribe_all(any, any) :: :ok | {:error, :no_station | list(term)}
  def subscribe_all(nil, _topic), do: {:error, :no_station}

  def subscribe_all(stations, topic) do
    stations
    |> Enum.map(&subscribe(&1, topic))
    |> Enum.reject(&(&1 == :ok))
    |> handle_errors()
  end

  # ------------------------ unsubscribing ------------
  @spec unsubscribe(topic) :: :ok | {:error, :no_station | term}
  def unsubscribe(topic) do
    unsubscribe(Telco.station(), topic)
  end

  @spec unsubscribe(station, topic) :: :ok | {:error, :no_station | term}
  def unsubscribe(nil, _topic), do: {:error, :no_station}

  def unsubscribe(station, topic) do
    topic_str = topic_as_string(topic)
    PubSub.unsubscribe(station, topic_str)
  end

  @spec unsubscribe_all(topic) :: :ok | {:error, :no_station | list(term)}
  def unsubscribe_all(topic) do
    unsubscribe_all(Telco.stations(), topic)
  end

  @spec unsubscribe_all(station, topic) :: :ok | {:error, :no_station | list(term)}
  def unsubscribe_all(nil, _topic), do: {:error, :no_station}

  def unsubscribe_all(stations, topic) do
    stations
    |> Enum.map(&unsubscribe(&1, topic))
    |> Enum.reject(&(&1 == :ok))
    |> handle_errors()
  end
end
