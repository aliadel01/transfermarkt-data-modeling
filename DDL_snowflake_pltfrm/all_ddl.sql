-- ============================================
-- TransferMarkt Data Warehouse - Snowflake DDL
-- ============================================
-- Database: TRANSFERMARKT_DW
-- Schema Version: 1.0
-- Star Schema: 4 Dimensions, 8 Facts
-- ============================================

-- Create Database and Schema
CREATE DATABASE IF NOT EXISTS TRANSFERMARKT_DW;
USE DATABASE TRANSFERMARKT_DW;

CREATE SCHEMA IF NOT EXISTS FOOTBALL_ANALYTICS;
USE SCHEMA FOOTBALL_ANALYTICS;

-- ============================================
-- DIMENSION TABLES
-- ============================================

-- --------------------------------------------
-- dim_player: Player Master Data
-- --------------------------------------------
CREATE OR REPLACE TABLE dim_player (
    player_id               INTEGER         NOT NULL,
    first_name              VARCHAR(500),
    last_name               VARCHAR(500),
    name                    VARCHAR(500),
    player_code             VARCHAR(500),
    country_of_birth        VARCHAR(500),
    city_of_birth           VARCHAR(500),
    country_of_citizenship  VARCHAR(500),
    date_of_birth           TIMESTAMP,
    position                VARCHAR(500),
    sub_position            VARCHAR(500),
    foot                    VARCHAR(500),
    height_in_cm            INTEGER,
    agent_name              VARCHAR(500),
    image_url               VARCHAR(500),
    url                     VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_dim_player PRIMARY KEY (player_id)
)
COMMENT = 'Player dimension containing static biographical and physical attributes';

-- Clustering key for common queries
ALTER TABLE dim_player CLUSTER BY (position, country_of_citizenship);

-- --------------------------------------------
-- dim_club: Club Master Data
-- --------------------------------------------
CREATE OR REPLACE TABLE dim_club (
    club_id                     INTEGER         NOT NULL,
    club_code                   VARCHAR(500),
    name                        VARCHAR(500),
    domestic_competition_id     VARCHAR(500),
    domestic_competition_name   VARCHAR(500),
    stadium_name                VARCHAR(500),
    stadium_seats               INTEGER,
    url                         VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_dim_club PRIMARY KEY (club_id)
)
COMMENT = 'Club dimension containing static club information';

-- Clustering key for common queries
ALTER TABLE dim_club CLUSTER BY (domestic_competition_id);

-- --------------------------------------------
-- dim_competition: Competition/League Data
-- --------------------------------------------
CREATE OR REPLACE TABLE dim_competition (
    competition_id              VARCHAR(500)    NOT NULL,
    competition_code            VARCHAR(500),
    name                        VARCHAR(500),
    sub_type                    VARCHAR(500),
    type                        VARCHAR(500),
    country_id                  INTEGER,
    country_name                VARCHAR(500),
    domestic_league_code        VARCHAR(500),
    confederation               VARCHAR(500),
    url                         VARCHAR(500),
    is_major_national_league    BOOLEAN,
    
    -- Constraints
    CONSTRAINT pk_dim_competition PRIMARY KEY (competition_id)
)
COMMENT = 'Competition dimension containing league and tournament information';

-- Clustering key for common queries
ALTER TABLE dim_competition CLUSTER BY (type, country_id);

-- --------------------------------------------
-- dim_game_details: Game Descriptive Attributes (Conformed Dimension)
-- --------------------------------------------
CREATE OR REPLACE TABLE dim_game_details (
    game_id                     INTEGER         NOT NULL,
    season                      INTEGER,
    round                       VARCHAR(500),
    date                        DATE,
    stadium                     VARCHAR(500),
    referee                     VARCHAR(500),
    home_club_manager_name      VARCHAR(500),
    away_club_manager_name      VARCHAR(500),
    aggregate                   VARCHAR(500),
    competition_type            VARCHAR(500),
    url                         VARCHAR(500),
    away_club_formation         VARCHAR(500),
    home_club_formation         VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_dim_game_details PRIMARY KEY (game_id)
)
COMMENT = 'Game details dimension - conformed dimension shared by multiple fact tables';

-- Clustering key for common queries
ALTER TABLE dim_game_details CLUSTER BY (season, date);

-- ============================================
-- FACT TABLES
-- ============================================

-- --------------------------------------------
-- fact_games: Game-Level Metrics
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_games (
    game_id                 INTEGER         NOT NULL,
    competition_id          VARCHAR(500)    NOT NULL,
    date                    DATE,
    home_club_id            INTEGER         NOT NULL,
    away_club_id            INTEGER         NOT NULL,
    home_club_goals         INTEGER,
    away_club_goals         INTEGER,
    home_club_position      INTEGER,
    away_club_position      INTEGER,
    attendance              INTEGER,
    
    -- Constraints
    CONSTRAINT pk_fact_games PRIMARY KEY (game_id),
    CONSTRAINT fk_fact_games_game_details FOREIGN KEY (game_id) 
        REFERENCES dim_game_details(game_id),
    CONSTRAINT fk_fact_games_competition FOREIGN KEY (competition_id) 
        REFERENCES dim_competition(competition_id),
    CONSTRAINT fk_fact_games_home_club FOREIGN KEY (home_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_games_away_club FOREIGN KEY (away_club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Game-level fact table containing match results and attendance';

-- Clustering key for time-series queries
ALTER TABLE fact_games CLUSTER BY (date, competition_id);

-- --------------------------------------------
-- fact_appearances: Player Game Statistics
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_appearances (
    appearance_id               VARCHAR(500)    NOT NULL,
    game_id                     INTEGER         NOT NULL,
    player_id                   INTEGER         NOT NULL,
    player_club_id              INTEGER         NOT NULL,
    player_current_club_id      INTEGER         NOT NULL,
    date                        DATE,
    competition_id              VARCHAR(500)    NOT NULL,
    yellow_cards                INTEGER,
    red_cards                   INTEGER,
    goals                       INTEGER,
    assists                     INTEGER,
    minutes_played              INTEGER,
    
    -- Constraints
    CONSTRAINT pk_fact_appearances PRIMARY KEY (appearance_id),
    CONSTRAINT fk_fact_appearances_game FOREIGN KEY (game_id) 
        REFERENCES dim_game_details(game_id),
    CONSTRAINT fk_fact_appearances_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_appearances_club FOREIGN KEY (player_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_appearances_current_club FOREIGN KEY (player_current_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_appearances_competition FOREIGN KEY (competition_id) 
        REFERENCES dim_competition(competition_id)
)
COMMENT = 'Player appearance fact table - LARGEST TABLE with 1.2M+ rows';

-- Clustering key for common query patterns (date-based and player-based queries)
ALTER TABLE fact_appearances CLUSTER BY (date, player_id);

-- --------------------------------------------
-- fact_club_games: Club Game Perspective
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_club_games (
    game_id                     INTEGER         NOT NULL,
    club_id                     INTEGER         NOT NULL,
    opponent_id                 INTEGER         NOT NULL,
    own_goals                   INTEGER,
    own_position                INTEGER,
    opponent_goals              INTEGER,
    opponent_position           INTEGER,
    is_win                      BOOLEAN,
    own_manager_name            VARCHAR(500),
    opponent_manager_name       VARCHAR(500),
    hosting                     VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_fact_club_games PRIMARY KEY (game_id, club_id),
    CONSTRAINT fk_fact_club_games_game FOREIGN KEY (game_id) 
        REFERENCES dim_game_details(game_id),
    CONSTRAINT fk_fact_club_games_club FOREIGN KEY (club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_club_games_opponent FOREIGN KEY (opponent_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Club game fact table - provides club-centric view of matches (2 rows per game)';

-- Clustering key for club-based queries
ALTER TABLE fact_club_games CLUSTER BY (club_id, game_id);

-- --------------------------------------------
-- fact_game_events: In-Game Events
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_game_events (
    game_event_id           VARCHAR(500)    NOT NULL,
    date                    DATE,
    game_id                 INTEGER         NOT NULL,
    player_id               INTEGER,
    club_id                 INTEGER         NOT NULL,
    player_in_id            INTEGER,
    player_assist_id        INTEGER,
    minute                  INTEGER,
    type                    VARCHAR(500),
    description             VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_fact_game_events PRIMARY KEY (game_event_id),
    CONSTRAINT fk_fact_game_events_game FOREIGN KEY (game_id) 
        REFERENCES dim_game_details(game_id),
    CONSTRAINT fk_fact_game_events_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_game_events_club FOREIGN KEY (club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_game_events_player_in FOREIGN KEY (player_in_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_game_events_player_assist FOREIGN KEY (player_assist_id) 
        REFERENCES dim_player(player_id)
)
COMMENT = 'Game events fact table - goals, cards, substitutions';

-- Clustering key for game-based and type-based queries
ALTER TABLE fact_game_events CLUSTER BY (game_id, type);

-- --------------------------------------------
-- fact_game_lineups: Game Squad Selection (Factless Fact)
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_game_lineups (
    lineup_id               VARCHAR(500)    NOT NULL,
    date                    DATE,
    game_id                 INTEGER         NOT NULL,
    player_id               INTEGER         NOT NULL,
    club_id                 INTEGER         NOT NULL,
    lineup_type             VARCHAR(500),
    position                VARCHAR(500),
    jersey_number           INTEGER,
    is_captain              BOOLEAN,
    
    -- Constraints
    CONSTRAINT pk_fact_game_lineups PRIMARY KEY (lineup_id),
    CONSTRAINT fk_fact_game_lineups_game FOREIGN KEY (game_id) 
        REFERENCES dim_game_details(game_id),
    CONSTRAINT fk_fact_game_lineups_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_game_lineups_club FOREIGN KEY (club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Game lineups fact table - factless fact tracking player squad selection';

-- Clustering key for game-based queries
ALTER TABLE fact_game_lineups CLUSTER BY (game_id, lineup_type);

-- --------------------------------------------
-- fact_player_valuations: Player Market Values Over Time
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_player_valuations (
    player_id                               INTEGER         NOT NULL,
    date                                    DATE            NOT NULL,
    current_club_id                         INTEGER,
    player_club_domestic_competition_id     VARCHAR(500),
    market_value_in_eur                     NUMBER(18, 2),
    
    -- Constraints
    CONSTRAINT pk_fact_player_valuations PRIMARY KEY (player_id, date),
    CONSTRAINT fk_fact_player_valuations_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_player_valuations_club FOREIGN KEY (current_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_player_valuations_competition FOREIGN KEY (player_club_domestic_competition_id) 
        REFERENCES dim_competition(competition_id)
)
COMMENT = 'Player valuations fact table - periodic snapshot of market values';

-- Clustering key for player-based time-series queries
ALTER TABLE fact_player_valuations CLUSTER BY (player_id, date);

-- --------------------------------------------
-- fact_transfers: Player Transfer Transactions
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_transfers (
    player_id               INTEGER         NOT NULL,
    transfer_date           DATE            NOT NULL,
    from_club_id            INTEGER,
    to_club_id              INTEGER,
    transfer_season         VARCHAR(500),
    transfer_fee            NUMBER(18, 2),
    market_value_in_eur     NUMBER(18, 2),
    
    -- Constraints
    CONSTRAINT pk_fact_transfers PRIMARY KEY (player_id, transfer_date),
    CONSTRAINT fk_fact_transfers_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_transfers_from_club FOREIGN KEY (from_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_transfers_to_club FOREIGN KEY (to_club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Transfer fact table - player transfer transactions between clubs';

-- Clustering key for player-based and date-based queries
ALTER TABLE fact_transfers CLUSTER BY (player_id, transfer_date);

-- --------------------------------------------
-- fact_club_snapshot: Club Metrics Over Time
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_club_snapshot (
    club_id                     INTEGER         NOT NULL,
    snapshot_date               DATE            NOT NULL,
    total_market_value          NUMBER(18, 2),
    squad_size                  INTEGER,
    average_age                 NUMBER(5, 2),
    foreigners_number           INTEGER,
    foreigners_percentage       NUMBER(5, 2),
    national_team_players       INTEGER,
    net_transfer_record         VARCHAR(500),
    coach_name                  VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_fact_club_snapshot PRIMARY KEY (club_id, snapshot_date),
    CONSTRAINT fk_fact_club_snapshot_club FOREIGN KEY (club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Club snapshot fact table - periodic snapshot of club metrics';

-- Clustering key for club-based time-series queries
ALTER TABLE fact_club_snapshot CLUSTER BY (club_id, snapshot_date);