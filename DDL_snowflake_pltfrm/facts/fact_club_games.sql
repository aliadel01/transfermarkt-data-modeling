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
