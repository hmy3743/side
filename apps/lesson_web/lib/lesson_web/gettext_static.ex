defmodule LessonWeb.GettextStatic do
  import LessonWeb.Gettext

  def static do
    dgettext("errors", "has already been taken")
    dgettext("errors", "is required")
  end
end
