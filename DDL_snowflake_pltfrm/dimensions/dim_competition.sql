-- --------------------------------------------
-- dim_competition: Competition/League Data
-- --------------------------------------------
CREATE OR REPLACE TABLE dim_competition
(
    competition_id              VARCHAR
(500)    NOT NULL,
    competition_code            VARCHAR
(500),
    name                        VARCHAR
(500),
    sub_type                    VARCHAR
(500),
    type                        VARCHAR
(500),
    country_id                  INTEGER,
    country_name                VARCHAR
(500),
    domestic_league_code        VARCHAR
(500),
    confederation               VARCHAR
(500),
    url                         VARCHAR
(500),
    is_major_national_league    BOOLEAN,
    
    -- Constraints
    CONSTRAINT pk_dim_competition PRIMARY KEY
(competition_id)
)
COMMENT = 'Competition dimension containing league and tournament information';

-- Clustering key for common queries
ALTER TABLE dim_competition CLUSTER BY
(type, country_id);
