-- --------------------------------------------
-- fact_club_snapshot: Club Metrics Over Time
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_club_snapshot (
    club_id                     INTEGER         NOT NULL,
    snapshot_date               DATE            NOT NULL,
    total_market_value          NUMBER(18, 2),
    squad_size                  INTEGER,
    average_age                 NUMBER(5, 2),
    foreigners_number           INTEGER,
    foreigners_percentage       NUMBER(5, 2),
    national_team_players       INTEGER,
    net_transfer_record         VARCHAR(500),
    coach_name                  VARCHAR(500),
    
    -- Constraints
    CONSTRAINT pk_fact_club_snapshot PRIMARY KEY (club_id, snapshot_date),
    CONSTRAINT fk_fact_club_snapshot_club FOREIGN KEY (club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Club snapshot fact table - periodic snapshot of club metrics';

-- Clustering key for club-based time-series queries
ALTER TABLE fact_club_snapshot CLUSTER BY (club_id, snapshot_date);
