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
