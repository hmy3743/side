defmodule LessonWeb.Router do
  use LessonWeb, :router
  import LessonWeb.Plugs
  alias LessonWeb.Admin.Account.JoiningRequestLive
  alias LessonWeb.OnMounts

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :set_locale_by_accept_language_header
    plug :fetch_live_flash
    plug :put_root_layout, {LessonWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LessonWeb do
    pipe_through :browser

    live_session :public, on_mount: {OnMounts, :set_locale} do
      live "/", IndexLive
      live "/request_joining", RequestJoiningLive
    end
  end

  scope "/admin", LessonWeb.Admin do
    pipe_through :browser

    live_session :admin, layout: {LessonWeb.Layouts, :admin}, on_mount: {OnMounts, :set_locale} do
      live "/", IndexLive

      scope "/account", Account do
        live "/application", JoiningRequestLive
        live "/editing", AccountEditingLive
        live "/creating", AccountCreatingLive
      end

      scope "/schedule", Schedule do
        live "/editing", ScheduleEditingLive
      end

      scope "/lesson", Lesson do
        live "/evaluating", LessonEvaluatingLive
      end

      scope "/statistic", Statistic do
        live "/teacher", StatisticTeacherLive
        live "/student", StatisticStudentLive
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", LessonWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:lesson_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LessonWeb.Telemetry
    end
  end
end
