defmodule Telco.Test do
  alias Telco.Support.ClusterCase
  use ExUnit.Case

  setup do
    nodes = ClusterCase.spawn([:test1, :test2])

    on_exit(fn ->
      ClusterCase.stop_all()
    end)

    [nodes: nodes]
  end

  test "Message on subscribed broadcast 'test_link", %{nodes: [{n1, _pid1}, {n2, _pid2}]} do
    broadcast_id = "test_link"
    message = "test message"

    # subscribe on node1
    ClusterCase.subscribe(n1, broadcast_id)

    # send a message from node 2
    ClusterCase.broadcast(n2, broadcast_id, message)

    # check that it was sent by node 2
    {[{_status, sent_msg}], _received} = ClusterCase.get_messages(n2)
    assert(sent_msg == message)

    # check that is was received by node 1
    {_sent, [{topic, received_msg}]} = ClusterCase.get_messages(n1)
    assert(received_msg == message)
    assert(topic == broadcast_id)
  end

  test "Message when not subscribed", %{nodes: [{n1, _pid1}, {n2, _pid2}]} do
    broadcast_id = "test_unlinked"
    message = "connected"

    # broadcast
    ClusterCase.broadcast(n2, broadcast_id, message)

    # check that the message was sent
    {[{_status, sent_msg}], _received} = ClusterCase.get_messages(n2)
    assert(sent_msg == message)

    # check that the message was NOT received
    {_sent, received} = ClusterCase.get_messages(n1)
    assert(received == [], "Node1 should not have recieved a message")
  end

  test "Can both send and received" do

  end

  test "Can send over multiple towers" do

  end
end
