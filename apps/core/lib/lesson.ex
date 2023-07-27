defmodule Lesson do
  use Ash.Api

  resources do
    registry Lesson.Registry
  end
end
