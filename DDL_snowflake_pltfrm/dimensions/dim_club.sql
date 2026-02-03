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
