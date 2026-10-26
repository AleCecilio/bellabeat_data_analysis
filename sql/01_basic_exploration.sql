-- ==============================================================================
-- ARQUIVO: 01_exploracao_basica.sql
-- OBJETIVO: Validação de consistência, tamanho da amostra e médias gerais.
-- ==============================================================================

-- ==============================================================================
-- PERGUNTA 1: Quantos utilizadores únicos temos em cada tabela?
-- OBJETIVO: Entender o tamanho real da nossa amostra. A tabela de peso costuma ter
-- uma adesão muito menor, o que é um insight importante para o negócio.
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
-- PERGUNTA 2: Qual é o período de tempo exato que estes dados cobrem?
-- OBJETIVO: Validar o intervalo cronológico da análise (saber quantos meses/dias).
-- ==============================================================================

SELECT 
    MIN(activity_date) AS data_inicio,
    MAX(activity_date) AS data_fim,
    MAX(activity_date) - MIN(activity_date) AS total_dias_analisados
FROM daily_activity;

-- ==============================================================================
-- PERGUNTA 3: Qual é o comportamento médio geral diário dos nossos utilizadores?
-- OBJETIVO: Criar uma "linha de base" (baseline) de saúde para comparar com 
-- as recomendações da OMS (Organização Mundial da Saúde).
-- ==============================================================================

SELECT 
    ROUND(AVG(total_steps), 0) AS media_passos_dia,
    ROUND(AVG(total_distance), 2) AS media_distancia_km,
    ROUND(AVG(calories), 0) AS media_calorias_queimadas
FROM daily_activity;

-- ==============================================================================
-- PERGUNTA 4: Qual é a média geral de sono da nossa base?
-- OBJETIVO: Baseline para comparar com as 8 horas recomendadas.
-- ==============================================================================

SELECT 
    ROUND(AVG(total_minutes_asleep) / 60, 2) AS media_horas_dormidas,
    ROUND(AVG(total_time_in_bed) / 60, 2) AS media_horas_na_cama,
    ROUND(AVG(total_time_in_bed - total_minutes_asleep), 0) AS media_minutos_acordado_na_cama
FROM sleep_day;

-- ==============================================================================
-- PERGUNTA 5: Qual é a consistência de uso do dispositivo (Fitbit/Bellabeat)?
-- OBJETIVO: Saber se as pessoas usam o aparelho todos os dias ou se abandonam.
-- ==============================================================================

SELECT 
    user_id,
    COUNT(activity_date) AS dias_de_uso,
    CASE 
        WHEN COUNT(activity_date) >= 21 THEN 'Uso Frequente (Alto)'
        WHEN COUNT(activity_date) BETWEEN 11 AND 20 THEN 'Uso Moderado'
        ELSE 'Uso Baixo'
    END AS categoria_engajamento
FROM daily_activity
GROUP BY user_id
ORDER BY dias_de_uso DESC;