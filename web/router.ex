defmodule Flash.Router do
  use Flash.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Flash do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/control", Flash do
    pipe_through :api

    post "/change", PageController, :change
    post "/sync",   PageController, :sync
  end
end
