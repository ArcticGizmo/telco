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
    |> case do
      [] -> :ok
      errors -> {:error, Enum.map(errors, &elem(&1, 1))}
    end
  end

  # ---------------------------- listening -------------------------
  @spec listen(topic) :: :ok | {:error, term}
  def listen(topic) do
    listen(Telco.station(), topic)
  end

  @spec listen(station, topic) :: :ok | {:error, any}
  def listen(nil, _topic), do: {:error, :no_station}

  def listen(station, topic) do
    topic_str = topic_as_string(topic)
    PubSub.subscribe(station, topic_str)
  end

  @spec listen_all(topic) :: :ok | {:error, :no_station | list(term)}
  def listen_all(topic) do
    listen(Telco.stations(), topic)
  end

  @spec listen_all(any, any) :: :ok | {:error, :no_station | list(term)}
  def listen_all(nil, _topic), do: {:error, :no_station}

  def listen_all(stations, topic) do
    stations
    |> Enum.map(&listen(&1, topic))
    |> Enum.reject(&(&1 == :ok))
    |> case do
      [] -> :ok
      errors -> {:error, Enum.map(errors, &elem(&1, 1))}
    end
  end
end
