defmodule Telco.Support.ClusterCase.Test do
  alias Telco.Support.ClusterCase
  use ExUnit.Case

  setup do
    nodes = ClusterCase.spawn([:test1, :test2])

    on_exit(fn ->
      ClusterCase.stop_all()
    end)

    [nodes: nodes]
  end

  test "Nodes connected on start", %{nodes: [{n1, _pid1}, {n2, _pid2}]} do
    assert(ClusterCase.connected?(n1, n2) == true)
  end
end
