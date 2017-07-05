defmodule Kennel.ExecWorker do
  use GenServer
  
  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end
  
  def init(state)  do
    {:command, command} = state
    {:ok, pid, os_pid} = Exexec.run_link(command, options())
    {:ok, {pid, os_pid}}
  end
  
  defp options do
    %{pty: true, stdin: true, stdout: true, stderr: true}
  end
  
  def handle_info({:stdout, _, _}, state), do: {:noreply, state}
  def handle_info({:stderr, _, _}, state), do: {:noreply, state}
  
  def command_for(executable_path, executable_flags) do
    Enum.join([String.replace(executable_path, " ", "\\ ")] ++ executable_flags, " ")
  end
end
