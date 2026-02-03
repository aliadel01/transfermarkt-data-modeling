-- ============================================
-- TransferMarkt Data Warehouse - Master DDL
-- ============================================
-- Execute this file to create all tables in the correct order
-- ============================================

-- Step 1: Database and Schema Setup
!source 00_database_setup.sql;

-- Step 2: Create Dimension Tables
!source dimensions/dim_player.sql;
!source dimensions/dim_club.sql;
!source dimensions/dim_competition.sql;
!source dimensions/dim_game_details.sql;

-- Step 3: Create Fact Tables
!source facts/fact_games.sql;
!source facts/fact_appearances.sql;
!source facts/fact_club_games.sql;
!source facts/fact_game_events.sql;
!source facts/fact_game_lineups.sql;
!source facts/fact_player_valuations.sql;
!source facts/fact_transfers.sql;
!source facts/fact_club_snapshot.sql;