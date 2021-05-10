class TweetBlueprint < Blueprinter::Base
  identifier :id

  fields :text

  association :user, blueprint: UserBlueprint
end