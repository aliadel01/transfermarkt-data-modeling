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
