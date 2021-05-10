class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :nickname, :email, :created_at
end