defmodule TimelineHandler do
  @behaviour :cowboy_http_handler

  def init({_any, :http}, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_http_req.reply(
      200,
      [{<<"content-type">>, <<"application/javascript">>}],
      "Pusher.JSONP.receive(1, null, {});",
      req
    )
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
