defmodule Telco.Logger do
  @moduledoc false

  require Logger

  @type level :: :debug | :info | :warn | :error
  @type strategy :: String.t() | nil

  @doc """
  Debug will not submit to the logger unless `debug: true`.
  This is to prevent overheads sending lots of messages to the logger
  """
  @spec log(level, strategy, String.t()) :: :ok | {:error, any}
  def log(level, strategy \\ nil, msg) do
    apply(__MODULE__, level, [strategy, msg])
  end

  @spec debug(strategy, String.t()) :: :ok | {:error, any}
  def debug(strategy \\ nil, msg) do
    case Application.get_env(:liaison, :debug) do
      true -> Logger.debug(log_msg(strategy, msg))
      _ -> :ok
    end
  end

  @spec info(strategy, String.t()) :: :ok | {:error, any}
  def info(strategy \\ nil, msg), do: Logger.info(log_msg(strategy, msg))

  @spec warn(strategy, String.t()) :: :ok | {:error, any}
  def warn(strategy \\ nil, msg), do: Logger.warn(log_msg(strategy, msg))

  @spec error(strategy, String.t()) :: :ok | {:error, any}
  def error(strategy, msg), do: Logger.error(log_msg(strategy, msg))

  defp log_msg(nil, msg), do: "[telco] #{msg}"
  defp log_msg(strategy, msg), do: "[telco:#{strategy}] #{msg}"
end
