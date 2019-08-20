defmodule Telco.Listener do
  @moduledoc """
  Telco listener allows users to listen in on broadcasters over connected nodes

  Genservers that use this functionality can subscribe at compile time
    through the using macro, at genserver start, or at any point
    during run time
  """

  defmacro __using__(_opts) do

  end
end
