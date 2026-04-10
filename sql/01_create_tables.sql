-- ============================================
-- 01_create_tables.sql
-- Kenya Deforestation Analysis
-- Author: Davis Mironga
-- Description: Create tables for all raw data sources
-- ============================================

-- Table 1: GFW tree cover loss by county and year
CREATE TABLE IF NOT EXISTS gfw_tree_cover_loss (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country TEXT,
    subnational_1 TEXT,        -- County name
    year INTEGER,
    tree_cover_loss_ha REAL,   -- Hectares lost that year
    co2_emissions_mt REAL      -- CO2 equivalent in megatonnes
);

-- Table 2: GFW tree cover loss by dominant driver
CREATE TABLE IF NOT EXISTS gfw_loss_by_driver (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country TEXT,
    subnational_1 TEXT,        -- County name
    year INTEGER,
    driver TEXT,               -- permanent agriculture, logging, wildfire etc.
    tree_cover_loss_ha REAL
);

-- Table 3: FAO FAOSTAT land use
CREATE TABLE IF NOT EXISTS faostat_land_use (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    area TEXT,                 -- Country name
    item TEXT,                 -- Forest land, Agricultural land etc.
    element TEXT,
    year INTEGER,
    value REAL,                -- Thousand hectares
    unit TEXT
);

-- Table 4: FAO Forest Resources Assessment
CREATE TABLE IF NOT EXISTS fao_fra (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country TEXT,
    year INTEGER,              -- 1990, 2000, 2010, 2015, 2020
    forest_area_ha REAL,
    natural_forest_ha REAL,
    planted_forest_ha REAL,
    carbon_stock_mt REAL
);

-- Table 5: World Bank indicators
CREATE TABLE IF NOT EXISTS worldbank_indicators (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country TEXT,
    indicator_code TEXT,       -- e.g. SI.POV.NAHC
    indicator_name TEXT,
    year INTEGER,
    value REAL
);