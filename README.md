# TripBook

The TripBook Project.

## Requirements

### System

* Linux or macOS
* Ruby 2.4
* Node.js 6.0+

### Database

* PostgreSQL 9.5+

### Backing Services

* Facebook
  * Env `FB_APP_ID`, `FB_APP_SECRET`
  * Needs to enable FB Login, the OAuth redirect URI is: `[your_host]/users/auth/facebook/callback`

## Setup

1. Run `bin/setup`.
2. Edit `.env`.
3. Edit `config/database.yml` and run `bin/rails db:setup` if needed.

## Development

### Tasks

- `bin/rake js:install`: Install JavaScript dependencies using NPM.
- `bin/rake erd:generate`: Generate ERD diagram for domain models (requires Graphviz 2.22+).
- `bin/rake syntax:check`: Check the code syntax using Rubocop.
- `bin/rake syntax:check_js`: Check JS code syntax using ESLint.
- `bin/rake syntax:auto_correct`: Auto correct the code syntax using Rubocop.
