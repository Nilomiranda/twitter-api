class FollowBlueprint < Blueprinter::Base
  identifier :id

  view :followers do
    association :follower, blueprint: UserBlueprint
  end

  view :following do
    association :following, blueprint: UserBlueprint
  end

  view :extended do
    include_views :followers, :following
  end
end