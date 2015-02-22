defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def init({_tcp, _http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    socket_id = UUID.uuid4
    :gproc.reg({ :p, :l, { :app, :sockets, socket_id }})
    { :ok, message } = JSX.encode(%{"event" => "pusher:connection_established", "data" => %{ "activity_timeout" => "12", "socket_id" => socket_id }})
    send self(), message
    {:ok, req, :undefined_state }
  end

  def websocket_handle({:text, content}, req, state) do
    { :ok, json } = JSX.decode(content)
    {:reply, {:text, handle_event(json["event"])}, req, state}
  end

  def websocket_handle(_data, req, state) do
    {:ok, req, state, :hibernate}
  end

  def websocket_info({timeout, _ref, _foo}, req, state) do
    { :reply, {:text, "{}"}, req, state}
  end

  def websocket_info(_info, req, state) do
    { :reply, {:text, _info}, req, :hibernate}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp handle_event("pusher:ping") do
    {:ok, res} = JSX.encode(%{ "event" => "pusher:pong", "data" => %{}})
    res
  end

  defp handle_event("pusher:subscribe") do
    :gproc.reg({ :p, :l, { :app, :channel }})
  end
end
