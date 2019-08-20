defmodule Telco do

  alias __MODULE__.Broadcaster

  def tower_name() do
    Application.get_env(:telco, :tower, :telco_tower)
  end

  def broadcast(server \\ tower_name(), broadcast_id, payload) do
    Broadcaster.broadcast(server, broadcast_id, payload)
  end



end
