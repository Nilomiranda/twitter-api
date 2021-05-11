# Twitter API

## Basics

- [x] Endpoint to determine if API is online

## User

- [X] Can create a new account
- [X] Can read account by id
- [X] Can delete account
- [X] Can update account


## Sessions / Authentication

- [X] Can create session (log in)
- [X] Can delete session (log out)

## Tweets

Logged user can:

- [X] Create a tweet
- [X] Read tweets
  - [X] Implement pagination
- [X] Read one tweet
- [X] Delete his tweet
- [X] Update his tweet

## TODO

 Right now, the filters to check for existence in `application_controller.rb` may have
 introduced the N+1 problem.
 Instead of actually selecting data, just use the `exists?` active record method.
 Leave the data loading to the controller itself.