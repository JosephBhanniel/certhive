defmodule CertWeb.Router do
  use CertWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CertWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :user do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CertWeb.LayoutView, :user}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :user_live do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CertWeb.LayoutView, :user_live}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CertWeb.LayoutView, :admin}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CertWeb.AuthFilter
  end

  scope "/", CertWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/register", PageController, :new
    post "/register", PageController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :delete

  end

  #Liveview Route for user module
  scope "/", CertWeb do
    pipe_through [:user_live]
    # live "/user", UserLive.Index
    # live "/user/:id", UserLive.Profile, :profile
    # live "/profile", UserLive, :user_profile
    # live "/edit", UserLive, :edit
    # live "/edit/:id", UserLive, :update
    # live "/certificates", UserLive, :index
    live "/user", UserLive.Index, :index
    live "/user/new", UserLive.Index, :new
    live "/user/:id/edit", UserLive.Index, :edit

    live "/user/:id", UserLive.Show, :show
    live "/user/:id/show/edit", UserLive.Show, :edit
  end

  pipeline :pdf do
    # We use our root layout pdf instead of root
    plug :put_root_layout, {CertWeb.LayoutView, :pdf}
    # We don't need a layout
    plug :put_layout, false
  end

  scope "/users", CertWeb do
    pipe_through [:user, :auth]
    get "/users", UserController, :index
    get "/profile", UserController, :user_profile
    get "/edit", UserController, :edit
    put "/edit/:id", UserController, :update
    get "/certificates", CertificateController, :index
  end

  scope "/users", CertWeb do
    pipe_through [:user, :pdf, :auth]
    # this route will use our root layout pdf and require our pdf.js and pdf.css
    get "/certificates/:id", CertificateController, :show
  end

  scope "/admin", CertWeb do
    pipe_through [:admin, :auth]
    get "/dashboard", AdminController, :index
    get "/users", AdminController, :users
    get "/profile", AdminController, :user_profile
    get "/edit", AdminController, :edit
    get "/view/:id", AdminController, :view
    put "/edit/:id", AdminController, :update
    put "/edit_user/:id", AdminController, :update_user
    get "/edit_user/:id", AdminController, :edit_user
    delete "/delete/:id", AdminController, :delete
  end



  # Other scopes may use custom stacks.
  # scope "/api", CertWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CertWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
