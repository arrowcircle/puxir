defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def init({_tcp, _http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport_name, req, _opts) do
    Puxir.Subscriber.init
    {:ok, req, :undefined_state }
  end

  def websocket_handle({:text, content}, req, state) do
    { :ok, json } = JSX.decode(content)
    {:reply, {:text, handle_event(json["event"], json, req)}, req, state}
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

  defp handle_event("pusher:ping", _json, _req) do
    {:ok, res} = JSX.encode(%{ "event" => "pusher:pong", "data" => %{}})
    res
  end

  defp handle_event("pusher:subscribe", json, req) do
    Puxir.Subscriber.subscribe(json, req)
  end
end
