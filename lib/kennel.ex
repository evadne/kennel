defmodule Kennel do
  use Application
  import Supervisor.Spec
  
  def start(_type, _args) do
    Supervisor.start_link([
      worker(Kennel.ExecWorker, [{:command, chrome_command()}], [id: :chrome]),
      worker(Kennel.ExecWorker, [{:command, chrome_driver_command()}], [id: :chrome_driver]),
      worker(Hound.ConnectionServer, [connection_options()]),
      worker(Hound.SessionServer, [])
    ], [
      strategy: :one_for_one,
      name: Kennel.Supervisor
    ])
  end
  
  defp chrome_driver_port do
    8888
  end
  
  defp chrome_port do
    8889
  end
  
  defp user_agent do
    Hound.Browser.user_agent(:chrome)
  end
  
  defp chrome_command do
    path = "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    flags = ~w(
      --headless
      --disable-gpu
      --user-agent="#{user_agent()}"
      --remote-debugging-port=#{chrome_port()}
    )
    Kennel.ExecWorker.command_for(path, flags)
  end

  defp chrome_driver_command do
    path = "/usr/local/bin/chromedriver"
    flags = ~w(--port=#{chrome_driver_port()})
    Kennel.ExecWorker.command_for(path, flags)
  end
  
  defp connection_options do
    [driver: "chrome_driver", port: chrome_driver_port()]
  end
  
  defp session_options do
    address = "127.0.0.1:#{chrome_port()}"
    [driver: %{chromeOptions: %{"debuggerAddress" => address}}]
  end
  
  def start_session do
    Hound.start_session(session_options())
  end
end
