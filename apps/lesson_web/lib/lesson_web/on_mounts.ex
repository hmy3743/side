defmodule LessonWeb.OnMounts do
  def on_mount(:set_locale, _params, sessions, socket) do
    locale = Map.get(sessions, "locale", "ko")
    Gettext.put_locale(LessonWeb.Gettext, locale)
    {:cont, socket}
  end
end
