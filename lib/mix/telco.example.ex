defmodule Mix.Tasks.Telco.Example do
  @moduledoc """
  This task creates an example instance that utilses Telco as a broadcaster
    and as a listener
  """

  use Mix.Task

  @shortdoc "Run an example application"
  def run(_cmd_string) do
    # start the telco application
    Application.ensure_all_started(:telco)

    # start an example broadcaster/listener
    # priint the module names for people to access
  end
end
