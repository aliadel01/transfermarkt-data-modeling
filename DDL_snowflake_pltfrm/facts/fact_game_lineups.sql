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
