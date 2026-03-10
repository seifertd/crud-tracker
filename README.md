# CRUD Tracker

A Ruby on Rails app for tracking games of [Crud](https://en.wikipedia.org/wiki/Crud_(game)), a game played on a pool table with a cue ball and one object ball. Records game results, calculates player scores, and maintains rankings and statistics.

## Features

- **Game management** - Create games, add players, track gameplay with an interactive strike-based UI
- **Player statistics** - PPG (points per game), win/place/show/last percentages
- **Dashboard** - Active games, recent completed games, top 5 players
- **Scoring** - Position-based points (1st=3, 2nd=2, 3rd=1, last=-1) plus bonus points

## Stack

- Ruby 3.3.10 (via [mise](https://mise.jdx.dev/))
- Rails 8.1
- SQLite3
- Bootstrap 5.3 (CDN)
- jQuery

## Setup

```bash
bundle install
bin/rails db:setup
```

## Running

```bash
mise exec -- bundle exec rails server
```

Then open http://localhost:3000.

## How It Works

### Scoring

Each completed game awards points based on finishing position:

| Place | Points | Bonus |
|-------|--------|-------|
| 1st | +3 | n-1 |
| 2nd | +2 | n-2 |
| 3rd | +1 | n-3 |
| Last | -1 | 0 |
| Other | 0 | n-position |

where `n` = number of players in the game.

Player rankings on the leaderboard use **PPG** (points per game), requiring a minimum of 5 games played.

### Game Lifecycle

1. Create a game and select players
2. The interactive game view tracks strikes per player (3 strikes = eliminated)
3. When one player remains, the game ends automatically and scores are recorded
4. If you want to play another match with the same players, easily replay

### Models

- `Player` - name, nickname, active status, cumulative points
- `Game` - started/completed state, player count
- `Entrant` - join model linking players to games; tracks position, strikes, alive status
