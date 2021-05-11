class TweetBlueprint < Blueprinter::Base
  identifier :id

  fields :text

  view :extended do
    association :user, blueprint: UserBlueprint
  end
end