defmodule GitPeer.Cli.Connect do
  @moduledoc """
  cli connect command
  """

  alias GitPeer.Daemon.Connect

  def optimus_config() do
    [
      name: "connect",
      about: "Allows you to connect to a git-peer node",
      subcommands: [
        list_ips: [
          name: "list-ips",
          help: "Lists your current IP addresses"
        ],
        get_connection_info: [
          name: "get-connection-info",
          help: "Get connection info"
        ],
      ]
    ]
  end

  def command({[:list_ips], _}, server) do
    GenServer.call({GitPeer.Daemon.Connect, server}, :list_ips)
  end
  # def command({[:list_ips], _}, server) do
  #   GenServer.call({GitPeer.Daemon.Connect, server}, {:join, connection_info})
  # end
  def command({[:get_connection_info], _}, server) do
    GenServer.call({GitPeer.Daemon.Connect, server}, :get_connection_info)
  end
end
