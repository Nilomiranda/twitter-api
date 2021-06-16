class TweetBlueprint < Blueprinter::Base
  identifier :id

  fields :text, :created_at, :liked

  view :extended do
    association :user, blueprint: UserBlueprint
  end
end