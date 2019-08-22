defmodule Telco.Support.ClusterCase do
  @moduledoc false

  alias Telco.Example

  @wait_duration 30_000
  @host "127.0.0.1"
  @master :"master@#{@host}"

  @doc """
  All nodes spawned using this are automatically connected
  """
  def spawn(nodes) do
    # Turn node into a distributed node with
    :net_kernel.monitor_nodes(true)
    :net_kernel.start([@master])

    # allow spawned nodes to fetch all code from this node
    :erl_boot_server.start([])
    allow_boot(to_charlist(@host))

    nodes
    |> Enum.map(&Task.async(fn -> spawn_node(&1) end))
    |> Enum.map(&Task.await(&1, @wait_duration))
    |> Enum.map(&elem(&1, 1))
  end

  defp spawn_node(node_host) do
    {:ok, node} = :slave.start(to_charlist(@host), node_name(node_host), inet_loader_args())

    add_code_paths(node)
    transfer_configuration(node)
    ensure_applications_started(node)

    {:ok, pid} = rpc(node, Telco.Application, :start, [nil, nil])

    # disable logging
    :ok = rpc(node, Logger, :configure, [[level: :warn]])

    # start example application
    {:ok, _pid} = rpc(node, Telco.Application, :start_example, [])

    {:ok ,{node, pid}}
  end

  def stop_all() do
    nodes = Node.list(:connected)

    nodes
    |> Enum.map(&Task.async(fn -> stop_node(&1) end))
    |> Enum.map(&Task.await(&1, @wait_duration))
  end

  def stop_node(node) do
    :ok = :slave.stop(node)
  end

  # ----------------------- helpers ---------------
  def subscribe(node, broadcast_id) do
    rpc(node, Example, :subscribe, [broadcast_id])
  end

  def broadcast(node, broadcast_id, message) do
    rpc(node, Example, :broadcast, [broadcast_id, message])
  end

  def get_messages(node) do
    rpc(node, Example, :get_messages, [])
  end

  def node_list(node) do
    rpc(node, Node, :list, [])
  end

  def connected?(node1, node2) do
    node_list(node1)
    |> Enum.member?(node2)
  end

  defp ensure_applications_started(node) do
    rpc(node, Application, :ensure_all_started, [:mix])
    rpc(node, Mix, :env, [Mix.env()])

    for {app_name, _, _} <- Application.loaded_applications() do
      rpc(node, Application, :ensure_all_started, [app_name])
    end
  end

  def rpc(node, module, function, args \\ []) do
    :rpc.block_call(node, module, function, args)
  end

  defp inet_loader_args() do
    '-loader inet -hosts #{@host} -connect_all true -setcookie #{:erlang.get_cookie()}'
  end

  defp allow_boot(host) do
    {:ok, ipv4} = :inet.parse_ipv4_address(host)
    :erl_boot_server.add_slave(ipv4)
  end

  defp add_code_paths(node) do
    rpc(node, :code, :add_paths, [:code.get_path()])
  end

  defp transfer_configuration(node) do
    for {app_name, _, _} <- Application.loaded_applications() do
      for {key, val} <- Application.get_all_env(app_name) do
        rpc(node, Application, :put_env, [app_name, key, val, [persistent: true]])
      end
    end
  end

  defp node_name(node_host) do
    node_host
    |> to_string
    |> String.split("@")
    |> Enum.at(0)
    |> String.to_atom()
  end
end
