defmodule Flash.PageController do
  use Flash.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def controller(conn, _params) do
    render conn, "controller.html"
  end

  def change(conn, %{"code" => code, "duration" => duration}) do
    Flash.Manager.change(code, duration)

    conn |> put_status(201) |> json ""
  end

  def sync(conn, _params) do
    Flash.Manager.sync

    conn |> put_status(201) |> json ""
  end

  def delay(conn, %{"delay" => delay, "code" => code, "duration" => duration}) do
    Flash.Manager.set_alarm(
      String.to_integer(delay),
      code,
      String.to_integer(duration)
    )

    conn |> put_status(201) |> json ""
  end
end
