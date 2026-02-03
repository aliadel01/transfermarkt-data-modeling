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
