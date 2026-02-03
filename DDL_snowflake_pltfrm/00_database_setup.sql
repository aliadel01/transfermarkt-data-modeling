-- ============================================
-- TransferMarkt Data Warehouse - Snowflake DDL
-- ============================================
-- Database: TRANSFERMARKT_DW
-- Schema Version: 1.0
-- Star Schema: 4 Dimensions, 8 Facts
-- ============================================

-- Create Database and Schema
CREATE DATABASE IF NOT EXISTS TRANSFERMARKT_DW;
USE DATABASE TRANSFERMARKT_DW;

CREATE SCHEMA IF NOT EXISTS FOOTBALL_ANALYTICS;
USE SCHEMA FOOTBALL_ANALYTICS;
