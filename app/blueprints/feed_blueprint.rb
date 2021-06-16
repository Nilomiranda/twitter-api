class FeedBlueprint < Blueprinter::Base
  identifier :id

  fields :id, :text, :liked

  association :user, blueprint: UserBlueprint
  association :comments, blueprint: CommentBlueprint
end