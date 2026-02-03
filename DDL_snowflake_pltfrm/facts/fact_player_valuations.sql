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
