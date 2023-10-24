defmodule Seed do
  def seed() do
    seed_user()
    seed_joining_request()
    seed_schedule()
  end

  @external_resource Util.path_in_priv("seed/user.yml")
  @data Util.read_data("seed/user.yml")
  defp seed_user() do
    Core.Account.bulk_create!(@data, Core.Account.User, :register_with_password)
  end

  @external_resource Util.path_in_priv("seed/joining_request.yml")
  @data Util.read_data("seed/joining_request.yml")
  defp seed_joining_request() do
    Core.Account.bulk_create!(@data, Lesson.JoiningRequest, :create)
  end

  # @external_resource Util.path_in_priv("seed/schedule.yml")
  # @data Util.read_data("seed/schedule.yml")
  defp seed_schedule() do
    # TODO
  end
end
