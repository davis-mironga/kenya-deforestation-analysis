-- ============================================
-- 02_load_data.sql
-- Kenya Deforestation Analysis
-- Author: Davis Mironga
-- Description: Load raw CSVs into SQLite tables
-- Run after 01_create_tables.sql
-- Usage: sqlite3 kenya_deforestation.db < sql/02_load_data.sql
-- ============================================

-- Enable CSV import mode
.mode csv
.headers on

-- ----------------------------------------
-- Load GFW tree cover loss by county/year
-- Expected file: data/raw/gfw_tree_cover_loss.csv
-- Columns: country, subnational_1, year, tree_cover_loss_ha, co2_emissions_mt
-- ----------------------------------------
.import data/raw/gfw_tree_cover_loss.csv gfw_tree_cover_loss_staging

INSERT INTO gfw_tree_cover_loss (country, subnational_1, year, tree_cover_loss_ha, co2_emissions_mt)
SELECT
    country,
    subnational_1,
    CAST(year AS INTEGER),
    CAST(tree_cover_loss_ha AS REAL),
    CAST(co2_emissions_mt AS REAL)
FROM gfw_tree_cover_loss_staging
WHERE country = 'Kenya'
  AND year BETWEEN 2001 AND 2024;

DROP TABLE IF EXISTS gfw_tree_cover_loss_staging;

-- ----------------------------------------
-- Load GFW tree cover loss by driver
-- Expected file: data/raw/gfw_loss_by_driver.csv
-- Columns: country, subnational_1, year, driver, tree_cover_loss_ha
-- ----------------------------------------
.import data/raw/gfw_loss_by_driver.csv gfw_loss_by_driver_staging

INSERT INTO gfw_loss_by_driver (country, subnational_1, year, driver, tree_cover_loss_ha)
SELECT
    country,
    subnational_1,
    CAST(year AS INTEGER),
    driver,
    CAST(tree_cover_loss_ha AS REAL)
FROM gfw_loss_by_driver_staging
WHERE country = 'Kenya'
  AND year BETWEEN 2001 AND 2024;

DROP TABLE IF EXISTS gfw_loss_by_driver_staging;

-- ----------------------------------------
-- Load FAO FAOSTAT land use
-- Expected file: data/raw/faostat_land_use.csv
-- Columns: area, item, element, year, value, unit
-- ----------------------------------------
.import data/raw/faostat_land_use.csv faostat_land_use_staging

INSERT INTO faostat_land_use (area, item, element, year, value, unit)
SELECT
    area,
    item,
    element,
    CAST(year AS INTEGER),
    CAST(value AS REAL),
    unit
FROM faostat_land_use_staging
WHERE area = 'Kenya';

DROP TABLE IF EXISTS faostat_land_use_staging;

-- ----------------------------------------
-- Load FAO Forest Resources Assessment
-- Expected file: data/raw/fao_fra.csv
-- Columns: country, year, forest_area_ha, natural_forest_ha, planted_forest_ha, carbon_stock_mt
-- ----------------------------------------
.import data/raw/fao_fra.csv fao_fra_staging

INSERT INTO fao_fra (country, year, forest_area_ha, natural_forest_ha, planted_forest_ha, carbon_stock_mt)
SELECT
    country,
    CAST(year AS INTEGER),
    CAST(forest_area_ha AS REAL),
    CAST(natural_forest_ha AS REAL),
    CAST(planted_forest_ha AS REAL),
    CAST(carbon_stock_mt AS REAL)
FROM fao_fra_staging
WHERE country = 'Kenya';

DROP TABLE IF EXISTS fao_fra_staging;

-- ----------------------------------------
-- Load World Bank indicators
-- Expected file: data/raw/worldbank_indicators.csv
-- Columns: country, indicator_code, indicator_name, year, value
-- ----------------------------------------
.import data/raw/worldbank_indicators.csv worldbank_indicators_staging

INSERT INTO worldbank_indicators (country, indicator_code, indicator_name, year, value)
SELECT
    country,
    indicator_code,
    indicator_name,
    CAST(year AS INTEGER),
    CAST(value AS REAL)
FROM worldbank_indicators_staging
WHERE country = 'Kenya';

DROP TABLE IF EXISTS worldbank_indicators_staging;

-- Verify row counts after load
SELECT 'gfw_tree_cover_loss' AS table_name, COUNT(*) AS rows FROM gfw_tree_cover_loss
UNION ALL
SELECT 'gfw_loss_by_driver', COUNT(*) FROM gfw_loss_by_driver
UNION ALL
SELECT 'faostat_land_use', COUNT(*) FROM faostat_land_use
UNION ALL
SELECT 'fao_fra', COUNT(*) FROM fao_fra
UNION ALL
SELECT 'worldbank_indicators', COUNT(*) FROM worldbank_indicators;
