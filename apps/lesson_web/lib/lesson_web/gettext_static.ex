defmodule LessonWeb.GettextStatic do
  import LessonWeb.Gettext

  def static do
    dgettext("errors", "has already been taken")
    dgettext("errors", "is required")

    gettext("male")
    gettext("female")
    gettext("etc")
    gettext("beginner")
    gettext("intermediate")
    gettext("advanced")
    gettext("business")
    gettext("travel")
    gettext("hobby")
  end
end
