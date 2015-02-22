defmodule Puxir.Subscriber do
  @moduledoc ~S"""
  Elixir's interactive shell.
  Subscriber module is used for channel subscriptions: public, private and presence.

  Public channels require no auth.

  Private channels are signed with backend and require auth.

  Presence channels are like private, but with ability to get channel presence info
  """

  @doc """
  Inits websocket connection, registers process and sends it to connected socket
  """
  def init do
    socket_id = UUID.uuid4
    register({ :app, :sockets, socket_id })
    { :ok, message } = JSX.encode(%{"event" => "pusher:connection_established", "data" => %{ "activity_timeout" => "30", "socket_id" => socket_id }})
    send self(), message
  end

  @doc """
  Registers current process with global or local gproc params.
  """
  def register(params) do
    :gproc.reg({ :p, :l, params })
  end

  @doc """
  Public method to handle subsriptions to public, private and presence channels
  """
  def subscribe(content, req) do
    register({ :app, :channel })
  end
end
