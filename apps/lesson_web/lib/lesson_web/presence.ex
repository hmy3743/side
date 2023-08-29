defmodule LessonWeb.Presence do
  use Phoenix.Presence,
    otp_app: :lesson_web,
    pubsub_server: LessonWeb.PubSub
end
