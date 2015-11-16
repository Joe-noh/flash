defmodule Flash.PageController do
  use Flash.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def change(conn, %{"code" => code, "period" => period}) do
    Flash.Manager.change(code, period)

    conn |> put_status(201) |> json ""
  end

  def sync(conn, _params) do
    Flash.Manager.sync

    conn |> put_status(201) |> json ""
  end
end
