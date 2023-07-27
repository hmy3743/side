defmodule Lesson.Registry do
  use Ash.Registry

  entries do
    entry Lesson.Schedule
  end
end
