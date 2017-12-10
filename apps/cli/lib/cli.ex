defmodule GitPeer.Cli do
  @moduledoc """
  Documentation for GitPeer.Cli.
  """

  alias GitPeer.Cli.{Review, Connect, Conflict, Branch}

  def main(argv) do
    args = optimus_config()
    |> Optimus.new!()
    |> Optimus.parse!(argv)

    {:ok, hostname} = :inet.gethostname()
    hostname = List.to_string(hostname)
    server = :"server@#{hostname}" |> IO.inspect()

    with :pong <- Node.ping(server) |> IO.inspect() do
      args
      |> command(server)
    else
      :pang -> {:error, "Unable to connect to #{server}"} |> IO.inspect(label: :pang)
      error -> error |> IO.inspect(label: :wtf?)
    end
  end

  defp command({[:review | subcommands], parse_result}, server) do
    Review.command({subcommands, parse_result}, server)
  end
  defp command({[:connect | subcommands], parse_result}, server) do
    Connect.command({subcommands, parse_result}, server)
  end
  defp command({[:conflict | subcommands], parse_result}, server) do
    Conflict.command({subcommands, parse_result}, server)
  end
  defp command({[:branch | subcommands], parse_result}, server) do
    Branch.command({subcommands, parse_result}, server)
  end

  def optimus_config() do
    [
      name: "git-peer",
      description: "A distributed Git collaboration tool",
      version: "0.0.1",
      author: "Olafur Arason",
      about: "A tool for sharing and reviewing your source code over a network in a peer to peer fashion.",
      allow_unknown_args: false,
      parse_double_dash: true,
      subcommands: [
        review: Review.optimus_config(),
        connect: Connect.optimus_config()
      ]
    ]
  end
end
