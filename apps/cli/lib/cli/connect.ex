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
        ]
      ]
    ]
  end

  def command({[:list_ips], _}, server) do
    GenServer.call({GitPeer.Daemon.Connect, server}, :list_ips)
  end
end