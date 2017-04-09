# TripBook [![Build Status](https://travis-ci.org/zetavg/TripBook.svg?branch=master)](https://travis-ci.org/zetavg/TripBook) [![Coverage Status](https://coveralls.io/repos/github/zetavg/TripBook/badge.svg?branch=master)](https://coveralls.io/github/zetavg/TripBook?branch=master)

The TripBook Project PR Test 1.

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

### Guard

Run `bin/guard` for autotest and livereload.
