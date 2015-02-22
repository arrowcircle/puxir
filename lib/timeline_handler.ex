defmodule TimelineHandler do
  @behaviour :cowboy_http_handler

  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    {version, req} = :cowboy_req.binding(:version, req)
    {:ok, req} = :cowboy_req.reply(
      200,
      [{"content-type", "application/javascript"}],
      version_request(version),
      req
    )
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def version_request("1") do
    "Pusher.JSONP.receive(1, null, {});"
  end

  def version_request("v2") do
    "Pusher.ScriptReceivers[1](null, {});"
  end

  def version_requires(_info) do
    ""
  end
end
