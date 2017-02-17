# TripBook

The TripBook Project.

## Requirements

### System

* Linux or macOS
* Ruby 2.4

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

- `bin/rake syntax:auto_correct`: Auto correct the code syntax using Rubocop.
