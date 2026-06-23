-- ============================================
-- 03_county_ranking.sql
-- Kenya Deforestation Analysis — Chapter 1
-- Author: Davis Mironga
-- Question: Which counties lose forest fastest?
-- ============================================

-- ----------------------------------------
-- Query 1: Total forest loss per county (2001–2024)
-- Ranks all counties by cumulative hectares lost
-- ----------------------------------------
SELECT
    subnational_1                           AS county,
    ROUND(SUM(tree_cover_loss_ha), 1)       AS total_loss_ha,
    ROUND(SUM(co2_emissions_mt), 3)         AS total_co2_mt,
    COUNT(DISTINCT year)                    AS years_with_data,
    ROUND(AVG(tree_cover_loss_ha), 1)       AS avg_annual_loss_ha
FROM gfw_tree_cover_loss
WHERE year BETWEEN 2001 AND 2024
GROUP BY subnational_1
ORDER BY total_loss_ha DESC;

-- ----------------------------------------
-- Query 2: Top 10 counties by total loss
-- ----------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(tree_cover_loss_ha) DESC) AS rank,
    subnational_1                                              AS county,
    ROUND(SUM(tree_cover_loss_ha), 1)                          AS total_loss_ha,
    ROUND(SUM(co2_emissions_mt), 3)                            AS total_co2_mt
FROM gfw_tree_cover_loss
WHERE year BETWEEN 2001 AND 2024
GROUP BY subnational_1
ORDER BY total_loss_ha DESC
LIMIT 10;

-- ----------------------------------------
-- Query 3: Annual loss trend — all counties
-- Used to plot the time-series chart
-- ----------------------------------------
SELECT
    year,
    subnational_1                       AS county,
    ROUND(tree_cover_loss_ha, 1)        AS loss_ha,
    ROUND(co2_emissions_mt, 4)          AS co2_mt
FROM gfw_tree_cover_loss
WHERE year BETWEEN 2001 AND 2024
ORDER BY subnational_1, year;

-- ----------------------------------------
-- Query 4: Peak loss year per county
-- Identifies when each county hit its worst year
-- ----------------------------------------
SELECT
    subnational_1                       AS county,
    year                                AS peak_year,
    ROUND(tree_cover_loss_ha, 1)        AS peak_loss_ha
FROM gfw_tree_cover_loss
WHERE (subnational_1, tree_cover_loss_ha) IN (
    SELECT subnational_1, MAX(tree_cover_loss_ha)
    FROM gfw_tree_cover_loss
    GROUP BY subnational_1
)
ORDER BY peak_loss_ha DESC;

-- ----------------------------------------
-- Query 5: Decade comparison — 2001–2012 vs 2013–2024
-- Shows whether deforestation is accelerating or slowing per county
-- ----------------------------------------
SELECT
    subnational_1                                   AS county,
    ROUND(SUM(CASE WHEN year BETWEEN 2001 AND 2012
                   THEN tree_cover_loss_ha ELSE 0 END), 1) AS loss_2001_2012_ha,
    ROUND(SUM(CASE WHEN year BETWEEN 2013 AND 2024
                   THEN tree_cover_loss_ha ELSE 0 END), 1) AS loss_2013_2024_ha,
    ROUND(
        SUM(CASE WHEN year BETWEEN 2013 AND 2024 THEN tree_cover_loss_ha ELSE 0 END) -
        SUM(CASE WHEN year BETWEEN 2001 AND 2012 THEN tree_cover_loss_ha ELSE 0 END),
    1) AS change_ha,
    CASE
        WHEN SUM(CASE WHEN year BETWEEN 2013 AND 2024 THEN tree_cover_loss_ha ELSE 0 END) >
             SUM(CASE WHEN year BETWEEN 2001 AND 2012 THEN tree_cover_loss_ha ELSE 0 END)
        THEN 'accelerating'
        ELSE 'slowing'
    END AS trend
FROM gfw_tree_cover_loss
WHERE year BETWEEN 2001 AND 2024
GROUP BY subnational_1
ORDER BY change_ha DESC;
