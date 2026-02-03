-- --------------------------------------------
-- fact_transfers: Player Transfer Transactions
-- --------------------------------------------
CREATE OR REPLACE TABLE fact_transfers (
    player_id               INTEGER         NOT NULL,
    transfer_date           DATE            NOT NULL,
    from_club_id            INTEGER,
    to_club_id              INTEGER,
    transfer_season         VARCHAR(500),
    transfer_fee            NUMBER(18, 2),
    market_value_in_eur     NUMBER(18, 2),
    
    -- Constraints
    CONSTRAINT pk_fact_transfers PRIMARY KEY (player_id, transfer_date),
    CONSTRAINT fk_fact_transfers_player FOREIGN KEY (player_id) 
        REFERENCES dim_player(player_id),
    CONSTRAINT fk_fact_transfers_from_club FOREIGN KEY (from_club_id) 
        REFERENCES dim_club(club_id),
    CONSTRAINT fk_fact_transfers_to_club FOREIGN KEY (to_club_id) 
        REFERENCES dim_club(club_id)
)
COMMENT = 'Transfer fact table - player transfer transactions between clubs';

-- Clustering key for player-based and date-based queries
ALTER TABLE fact_transfers CLUSTER BY (player_id, transfer_date);
