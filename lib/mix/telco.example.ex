defmodule Mix.Tasks.Telco.Example do
  @moduledoc """
  This task creates an example instance that utilses Telco as a broadcaster
    and as a listener
  """

  @start_cmd "iex --sname {name} -S mix telcoa.example"

  @not_connected """
  The appliccation was started without being connected as a node.
  Without this connection, messages can only be sent to yourself.

  Use the command
    > #{@start_cmd}
  """

  use Mix.Task

  @shortdoc "Run an example application"
  def run(_cmd_string) do
    case IEx.started?() do
      true -> start_example()
      false -> instructions()
    end
  end

  defp instructions() do
    IO.puts("""
    To start the example, use the following command

    >#{@start_cmd}
    """)
  end

  defp start_example() do
    # start the telco application
    Application.ensure_all_started(:telco)

    # start the Example
    Telco.Application.start_example()

    show_connect_command()
  end

  defp show_connect_command() do
    id = node()
    cmd = """
    The following are a list of commands to help you get started

    Connect from another example
    ===========================
    Run the following command is another example to connect to this one
    > Node.connect(:#{id})

    Check Connection
    ================
    The node of the other example should appear in the following list
    > Node.list()

    Subscribe
    ==========
    To subscribe to a particular station
    > Telco.Example.subscribe("station")

    One subscription you will see
      `[telco:listener] subscribed to 'station'`

    Broadcast
    ==========
    To broadcast a message over a particular station.
    > Telco.Example.broadcast("station", "hello")

    The sending node will see
      `[telco:broadcaster] on: 'station' => 'hello'`

    Once the message has bene sent, the recieving node will get
      `[telco:listener] on: 'station' => 'hello'`
    """

    case id do
      :nonode@nohost -> IO.puts(@not_connected)
      _ -> IO.puts(cmd)
    end
  end
end
