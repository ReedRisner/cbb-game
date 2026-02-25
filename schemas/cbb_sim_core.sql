-- Core relational schema for the College Basketball Coach Simulation.

CREATE TABLE conferences (
  conference_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  prestige NUMERIC(5,2) NOT NULL,
  media_value NUMERIC(12,2) NOT NULL,
  auto_bid BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  conference_id INT REFERENCES conferences(conference_id),
  name TEXT NOT NULL UNIQUE,
  historical_prestige NUMERIC(5,2) NOT NULL,
  current_prestige NUMERIC(5,2) NOT NULL,
  facilities NUMERIC(5,2) NOT NULL,
  nil_collective_strength NUMERIC(5,2) NOT NULL,
  booster_budget NUMERIC(12,2) NOT NULL,
  fan_intensity NUMERIC(5,2) NOT NULL,
  market_index NUMERIC(5,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE coaches (
  coach_id SERIAL PRIMARY KEY,
  team_id INT REFERENCES teams(team_id),
  full_name TEXT NOT NULL,
  offense_iq NUMERIC(5,2) NOT NULL,
  defense_iq NUMERIC(5,2) NOT NULL,
  recruiting_skill NUMERIC(5,2) NOT NULL,
  development_skill NUMERIC(5,2) NOT NULL,
  charisma NUMERIC(5,2) NOT NULL,
  discipline NUMERIC(5,2) NOT NULL,
  loyalty NUMERIC(5,2) NOT NULL,
  contract_years_remaining INT NOT NULL,
  annual_salary NUMERIC(12,2) NOT NULL,
  buyout_multiplier NUMERIC(4,2) NOT NULL
);

CREATE TABLE players (
  player_id BIGSERIAL PRIMARY KEY,
  team_id INT REFERENCES teams(team_id),
  full_name TEXT NOT NULL,
  class_year TEXT NOT NULL,
  position TEXT NOT NULL,
  height_inches INT NOT NULL,
  weight_lbs INT NOT NULL,
  attributes_json JSONB NOT NULL,
  tendencies_json JSONB NOT NULL,
  personality_json JSONB NOT NULL,
  potential_true NUMERIC(5,2) NOT NULL,
  potential_visible NUMERIC(5,2) NOT NULL,
  morale NUMERIC(5,2) NOT NULL,
  academics NUMERIC(5,2) NOT NULL,
  injury_profile NUMERIC(5,2) NOT NULL,
  eligibility_years_remaining INT NOT NULL,
  nba_interest NUMERIC(5,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE recruits (
  recruit_id BIGSERIAL PRIMARY KEY,
  class_year INT NOT NULL,
  full_name TEXT NOT NULL,
  stars INT NOT NULL,
  national_rank INT,
  position TEXT NOT NULL,
  home_region TEXT NOT NULL,
  attributes_true_json JSONB NOT NULL,
  attributes_est_json JSONB NOT NULL,
  personality_json JSONB NOT NULL,
  commitment_team_id INT REFERENCES teams(team_id),
  status TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE recruit_interests (
  recruit_id BIGINT REFERENCES recruits(recruit_id),
  team_id INT REFERENCES teams(team_id),
  interest_score NUMERIC(6,3) NOT NULL,
  PRIMARY KEY (recruit_id, team_id)
);

CREATE TABLE transfers (
  transfer_id BIGSERIAL PRIMARY KEY,
  player_id BIGINT REFERENCES players(player_id),
  from_team_id INT REFERENCES teams(team_id),
  to_team_id INT REFERENCES teams(team_id),
  entry_reason_codes TEXT[] NOT NULL,
  eligibility_status TEXT NOT NULL,
  nil_delta NUMERIC(12,2) NOT NULL,
  transfer_season INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE nil_deals (
  deal_id BIGSERIAL PRIMARY KEY,
  player_id BIGINT REFERENCES players(player_id),
  team_id INT REFERENCES teams(team_id),
  annual_amount NUMERIC(12,2) NOT NULL,
  term_years INT NOT NULL,
  incentives_json JSONB NOT NULL,
  sponsor_type TEXT NOT NULL,
  compliance_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE games (
  game_id BIGSERIAL PRIMARY KEY,
  season INT NOT NULL,
  game_date DATE NOT NULL,
  home_team_id INT REFERENCES teams(team_id),
  away_team_id INT REFERENCES teams(team_id),
  home_score INT,
  away_score INT,
  possessions INT,
  overtime_count INT NOT NULL DEFAULT 0,
  is_neutral BOOLEAN NOT NULL DEFAULT FALSE,
  game_type TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE play_by_play (
  event_id BIGSERIAL PRIMARY KEY,
  game_id BIGINT REFERENCES games(game_id),
  possession_no INT NOT NULL,
  period INT NOT NULL,
  clock_seconds_remaining INT NOT NULL,
  offense_team_id INT REFERENCES teams(team_id),
  defense_team_id INT REFERENCES teams(team_id),
  actor_player_id BIGINT REFERENCES players(player_id),
  event_type TEXT NOT NULL,
  expected_value NUMERIC(6,3),
  result_json JSONB
);

CREATE TABLE rankings (
  ranking_id BIGSERIAL PRIMARY KEY,
  season INT NOT NULL,
  week_no INT NOT NULL,
  team_id INT REFERENCES teams(team_id),
  ap_rank INT,
  coaches_rank INT,
  net_rank INT,
  adj_o NUMERIC(6,2),
  adj_d NUMERIC(6,2),
  adj_em NUMERIC(6,2),
  resume_score NUMERIC(7,3),
  bracket_seed_projection INT
);

CREATE TABLE awards (
  award_id BIGSERIAL PRIMARY KEY,
  season INT NOT NULL,
  award_type TEXT NOT NULL,
  recipient_player_id BIGINT REFERENCES players(player_id),
  recipient_coach_id BIGINT,
  team_id INT REFERENCES teams(team_id),
  metadata_json JSONB
);

CREATE TABLE history_snapshots (
  snapshot_id BIGSERIAL PRIMARY KEY,
  season INT NOT NULL,
  team_id INT REFERENCES teams(team_id),
  wins INT NOT NULL,
  losses INT NOT NULL,
  conference_finish INT,
  postseason_result TEXT,
  net_finish INT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_players_team_id ON players(team_id);
CREATE INDEX idx_games_season_date ON games(season, game_date);
CREATE INDEX idx_pbp_game_poss ON play_by_play(game_id, possession_no);
CREATE INDEX idx_rankings_season_week ON rankings(season, week_no);
