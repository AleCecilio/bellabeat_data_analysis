-- ==============================================================================
-- ARQUIVO: 01_engagement_and_daily_usage.sql
-- OBJETIVO: Identificar como é o hábito de uso do dispositivo inteligente.
-- ==============================================================================

-- ==============================================================================
-- Quantos utilizadores únicos temos em cada tabela?
-- ==============================================================================

SELECT 
    'Atividade Diária' AS tabela, 
    COUNT(DISTINCT user_id) AS total_utilizadores 
FROM daily_activity
UNION ALL
SELECT 
    'Sono Diário', 
    COUNT(DISTINCT user_id) 
FROM sleep_day
UNION ALL
SELECT 
    'Passos por Hora', 
    COUNT(DISTINCT user_id) 
FROM hourly_steps
UNION ALL
SELECT 
    'Registo de Peso', 
    COUNT(DISTINCT user_id) 
FROM weight_log;

-- ==============================================================================
--  Qual é o período de tempo exato que estes dados cobrem?
-- ==============================================================================

SELECT 
    MIN(activity_date) AS data_inicio,
    MAX(activity_date) AS data_fim,
    MAX(activity_date) - MIN(activity_date) AS total_dias_analisados
FROM daily_activity;

-- ==============================================================================
-- Qual é o comportamento médio geral diário dos nossos utilizadores?
-- ==============================================================================

SELECT 
    ROUND(AVG(total_steps), 0) AS media_passos_dia,
    ROUND(AVG(total_distance), 2) AS media_distancia_km,
    ROUND(AVG(calories), 0) AS media_calorias_queimadas
FROM daily_activity;

-- ==============================================================================
-- Qual é a média geral de sono da nossa base?
-- ==============================================================================

SELECT 
    ROUND(AVG(total_minutes_asleep) / 60, 2) AS media_horas_dormidas,
    ROUND(AVG(total_time_in_bed) / 60, 2) AS media_horas_na_cama,
    ROUND(AVG(total_time_in_bed - total_minutes_asleep), 0) AS media_minutos_acordado_na_cama
FROM sleep_day;

-- ==============================================================================
-- Qual é a consistência de uso do dispositivo (Fitbit/Bellabeat)?
-- ==============================================================================

WITH uso_por_utilizador AS (
    SELECT 
        user_id,
        COUNT(activity_date) AS dias_de_uso
    FROM daily_activity
    GROUP BY user_id
)
SELECT 
    CASE 
        WHEN dias_de_uso >= 21 THEN '1. Uso Assíduo (21 a 31 dias)'
        WHEN dias_de_uso BETWEEN 11 AND 20 THEN '2. Uso Moderado (11 a 20 dias)'
        ELSE '3. Uso Esporádico (1 a 10 dias)'
    END AS categoria_de_uso,
    COUNT(user_id) AS total_utilizadores,
    ROUND(
        (COUNT(user_id) / (SELECT COUNT(DISTINCT user_id) FROM daily_activity)
    ) * 100, 2) AS percentual_da_base
FROM uso_por_utilizador
GROUP BY
    CASE 
        WHEN dias_de_uso >= 21 THEN '1. Uso Assíduo (21 a 31 dias)'
        WHEN dias_de_uso BETWEEN 11 AND 20 THEN '2. Uso Moderado (11 a 20 dias)'
        ELSE '3. Uso Esporádico (1 a 10 dias)'
    END
ORDER BY categoria_de_uso;

-- ==============================================================================
-- No dia a dia, quantas horas as pessoas ficam com o aparelho no corpo?
-- ==============================================================================
WITH tempo_de_uso AS (
    SELECT 
        user_id,
        (very_active_minutes + 
         fairly_active_minutes + 
         lightly_active_minutes + 
         sedentary_minutes) / 60 AS horas_no_dia
    FROM daily_activity
)
SELECT 
    user_id,
    ROUND(AVG(horas_no_dia), 1) AS media_horas_uso_diario,
    CASE
        WHEN ROUND(AVG(horas_no_dia), 1) >= 24 THEN 'Usa 24h por dia'
        WHEN ROUND(AVG(horas_no_dia), 1) >= 16 THEN 'Usa o dia todo (16h-23h)'
        WHEN ROUND(AVG(horas_no_dia), 1) >= 8 THEN '3. Uso Parcial / Diurno (8h - 15h)'
        ELSE '4. Uso Pontual / Apenas Sono ou Treino (< 8h)'
    END AS padrao_de_uso
FROM tempo_de_uso
GROUP BY user_id
ORDER BY media_horas_uso_diario DESC;

-- -------------------------------------------------------------------------------
-- Consulta de auxílio, percentual por categoria de tempo de uso
-- -------------------------------------------------------------------------------

WITH media_por_utilizador AS (
    SELECT 
        user_id,
        AVG(
            (
                very_active_minutes + 
                fairly_active_minutes + 
                lightly_active_minutes + 
                sedentary_minutes
            ) / 60
        ) AS media_horas_uso_diario
    FROM daily_activity
    GROUP BY user_id
)
SELECT 
    CASE
        WHEN ROUND(media_horas_uso_diario, 1) >= 23.5 THEN '1. Uso Contínuo (~24h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 16 THEN '2. Uso Diário Alto (16h - 23h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 8 THEN '3. Uso Parcial / Diurno (8h - 15h)'
        ELSE '4. Uso Pontual / Apenas Sono ou Treino (< 8h)'
    END AS categoria_de_uso,
    COUNT(user_id) AS total_utilizadores,
    ROUND(
        (COUNT(user_id) / (SELECT COUNT(DISTINCT user_id) FROM daily_activity)
    ) * 100, 2) AS percentual_da_base
FROM media_por_utilizador
GROUP BY 
    CASE
        WHEN ROUND(media_horas_uso_diario, 1) >= 23.5 THEN '1. Uso Contínuo (~24h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 16 THEN '2. Uso Diário Alto (16h - 23h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 8 THEN '3. Uso Parcial / Diurno (8h - 15h)'
        ELSE '4. Uso Pontual / Apenas Sono ou Treino (< 8h)'
    END
ORDER BY categoria_de_uso;


-- ==============================================================================
-- Em quais dias da semana o dispositivo é mais ignorado/esquecido?
-- ==============================================================================
WITH registros_diarios AS (
    SELECT
        day_of_week,
        COUNT(user_id) AS total_registros,
        ROUND(AVG(total_steps), 0) AS media_de_passos,
        ROUND(AVG(total_distance), 2) AS distancia_media 
    FROM daily_activity
    GROUP BY day_of_week
)
SELECT 
    day_of_week,
    total_registros,
    media_de_passos,
    distancia_media,
    ROUND((total_registros / SUM(total_registros) OVER ()) * 100, 2) AS percentual_da_base
FROM registros_diarios
ORDER BY total_registros DESC;