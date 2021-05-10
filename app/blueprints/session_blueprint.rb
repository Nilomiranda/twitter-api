class SessionBlueprint < Blueprinter::Base
  fields :token

  association :user, blueprint: UserBlueprint
end