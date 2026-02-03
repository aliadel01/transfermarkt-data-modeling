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
