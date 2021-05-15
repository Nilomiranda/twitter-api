class FeedBlueprint < Blueprinter::Base
  identifier :id

  fields :id, :text

  association :user, blueprint: UserBlueprint
end