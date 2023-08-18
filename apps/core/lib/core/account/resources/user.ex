defmodule Core.Account.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string, allow_nil?: false
    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false
    attribute :gender, :atom, constraints: [one_of: [:male, :female, :etc]], allow_nil?: false
    attribute :birth, :date, allow_nil?: false

    attribute :level, :atom,
      constraints: [one_of: [:beginner, :intermediate, :advanced]],
      allow_nil?: false

    attribute :purpose, :atom,
      constraints: [one_of: [:business, :travel, :hobby, :etc]],
      allow_nil?: false

    attribute :comment, :string, constraints: [max_length: 1000], default: "", allow_nil?: false

    attribute :kakao_profile, :string, allow_nil?: true
    attribute :skype_profile, :string, allow_nil?: true
    attribute :hashed_password, :string, sensitive?: true

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  authentication do
    api Core.Account

    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
        confirmation_required? false
        register_action_name :register
      end
    end

    tokens do
      enabled? true
      token_resource Core.Account.Token

      signing_secret fn _, _ ->
        Application.fetch_env(:core, :token_signing_secret)
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  postgres do
    table "user"
    repo Core.Repo
  end

  relationships do
    has_many :published_feed_items, Core.SNS.FeedItem,
      destination_attribute: :author_id,
      api: Core.SNS

    has_many :published_sub_feed_items, Core.SNS.SubFeedItem,
      destination_attribute: :author_id,
      api: Core.SNS

    many_to_many :followers, Core.Account.User,
      through: Core.Account.Follow,
      source_attribute_on_join_resource: :followee_id,
      destination_attribute_on_join_resource: :follower_id

    many_to_many :followees, Core.Account.User,
      through: Core.Account.Follow,
      source_attribute_on_join_resource: :follower_id,
      destination_attribute_on_join_resource: :followee_id

    many_to_many :feeds, Core.SNS.FeedItem,
      through: Core.SNS.Feed,
      source_attribute_on_join_resource: :owner_id,
      destination_attribute_on_join_resource: :feed_item_id,
      api: Core.SNS
  end
end
