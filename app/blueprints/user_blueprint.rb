class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :nickname, :email, :created_at, :followers_count, :following_count
end