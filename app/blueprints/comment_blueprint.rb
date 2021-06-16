class CommentBlueprint < Blueprinter::Base
  identifier :id

  fields :content

  association :user, blueprint: UserBlueprint
end