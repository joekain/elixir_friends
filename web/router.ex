defmodule ElixirFriends.Router do
  use ElixirFriends.Web, :router
  use Honeybadger.Plug

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

  scope "/", ElixirFriends do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :index
    resources "/posts", PostController, only: [:show]
  end

  # Other scopes may use custom stacks.
  scope "/api", ElixirFriends do
    pipe_through :api

    resources "/posts", API.PostController, only: [:index]
  end

  scope "/auth", ElixirFriends do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
end
