# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#

# Seed with users
#

require 'faker'

tweets = []

generator_index = 0

while generator_index <= 100 do
  random_id = rand(10..120)

  tweets_index = 0

  while tweets_index <= 20 do
    tweets.push({ text: Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4), user_id: random_id })
    tweets_index = tweets_index + 1

    puts("tweets_index", tweets_index)
  end

  generator_index = generator_index + 1
end

unless tweets.length === 0
  Tweet.create(tweets)
end
