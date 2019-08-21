import IO.ANSI

instructions = """
For test to run, epmd must be started. This is usually called through `epmd -daemon`
If you cannot call this for some reason, try the following

`iex --sname name`

then exit out of the shell (ctrl/cmd + c)
"""

# this tests to see if epmd is started
epmd_started? =
  case :net_kernel.start([:a@b]) do
    {:error, _reason} ->
      false

    _ ->
      :net_kernel.stop()
      true
  end

if epmd_started? == false do
  try do
    System.cmd("epmd", ["-daemon"])
  rescue
    error ->
      IO.puts(:stderr, "#{red()}Tried to run 'empd -daemon' but the following occured: \n#{inspect(error)} #{reset()}")
      IO.puts(:stderr, instructions)

      System.halt()
  end
end

ExUnit.start()
