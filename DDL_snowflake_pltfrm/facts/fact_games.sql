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
