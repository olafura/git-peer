defmodule GitPeer.Daemon.Connect do
  @moduledoc "Functions related to network connectivity"

  use GenServer

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def parse_ip(ip) when is_tuple(ip) do
    {:ok, ip}
  end

  def parse_ip(ip) when is_binary(ip) do
    ip
    |> String.to_charlist()
    |> :inet_parse.address()
  end

  def list_ips do
    GenServer.call(__MODULE__, :list_ips)
  end

  def join(connection_info) do
    GenServer.call(__MODULE__, {:join, connection_info})
  end

  def get_connection_info do
    GenServer.call(__MODULE__, :get_connection_info)
  end

  def get_partisan_info do
    :partisan_peer_service_manager.myself()
  end

  def handle_call(:list_ips, _from, state) do
    reply = with {:ok, ips} <- :inet.getifaddrs() do
      response = ips
      |> Enum.reduce([], fn {key, features}, acc ->
           flags = Keyword.get(features, :flags, [])
           addr = Keyword.get(features, :addr, nil)

           if :multicast in flags and is_tuple(addr) do
             [{List.to_string(key), addr} | acc]
           else
             acc
           end
         end)
      |> Enum.into(%{})

      {:ok, response}
    end
    {:reply, reply, state}
  end

  def handle_call({:join, connection_info}, _from, state) do
    reply = :lasp_peer_service.join(connection_info)

    {:reply, {:ok, reply}, state}
  end

  def handle_call(:get_connection_info, _from, state) do
    reply = get_partisan_info()
    |> Map.take([:listen_addrs, :name])

    {:reply, {:ok, reply}, state}
  end
end
