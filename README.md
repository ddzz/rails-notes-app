# Note Taking Rails App

## Set up
  * Verify that you are running a recent version of Ruby.
  * Clone this repo.
  * Run `bundle install`.
  * Run rake tasks to create the database (`db:create`, `db:migrate`).
  * Open a Rails console and create a `User` account.
  * Run `bundle exec rails server`.
  * Start taking notes!

## Notes
  * Tests are in the `/spec/` directory.
  * This app supports emailing of notes. Email credentials need to be entered in `/config/environments/`.
  * SQLite is used in the development environment and PostgreSQL is used in production.

## Deploy notes
  * This app has been deployed to Heroku at https://note-taking-app-dev.herokuapp.com/.

## Notes on Gems used
  * I've created this application with a small number of gems. Most are gems that are included by default when you create a new Rails application, but a few are not.
  * `bcrypt` is used for handling user passwords securely.
  * `bootstrap-sass` is used for styling and design.
  * `rspec-rails` and `rails-controller-testing` are used for testing.
