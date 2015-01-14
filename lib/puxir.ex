defmodule Puxir do
  @behaviour :application

  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [
        {"/", :cowboy_static, {:priv_file, :puxir, "index.html"}},
        {"/timeline/:id", TimelineHandler, []},
        {"/websocket", WsHandler, []},
        ]
      }
    ])
    {:ok, _} = :cowboy.start_http(:http, 100, [{:port, 4000}],
    [{:env, [{:dispatch, dispatch}]}])
    PuxirSupervisor.start_link
  end

  def stop(_state) do
    :ok
  end
end
