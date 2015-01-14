defmodule TimelineHandler do
  @behaviour :cowboy_http_handler

  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply(
      200,
      [{"content-type", "application/javascript"}],
      "Pusher.JSONP.receive(1, null, {});",
      req
    )
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
