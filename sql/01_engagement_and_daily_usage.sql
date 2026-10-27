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
    'Atividade Diária' AS tabela,
    MIN(activity_date) AS data_inicio,
    MAX(activity_date) AS data_fim,
    MAX(activity_date) - MIN(activity_date) AS total_dias_analisados
FROM daily_activity
UNION ALL
SELECT 
    'Sono Diário',
    MIN(sleep_date) AS data_inicio,
    MAX(sleep_date) AS data_fim,
    MAX(sleep_date) - MIN(sleep_date) AS total_dias_analisados
FROM sleep_day
UNION ALL
SELECT 
    'Passos por Hora',
    MIN(TRUNC(activity_hour)) AS data_inicio,
    MAX(TRUNC(activity_hour)) AS data_fim,
    MAX(TRUNC(activity_hour)) - MIN(TRUNC(activity_hour)) AS total_dias_analisados
FROM hourly_steps
UNION ALL
SELECT 
    'Registo de Peso',
    MIN(weight_date) AS data_inicio,
    MAX(weight_date) AS data_fim,
    MAX(weight_date) - MIN(weight_date) AS total_dias_analisados
FROM weight_log;


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
    ROUND((
        COUNT(user_id) / (SELECT COUNT(DISTINCT user_id) FROM daily_activity)
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

-- ==============================================================================
-- Qual é o nível de adoção e consistência do rastreio de sono?
-- ==============================================================================
WITH consistencia_sono AS (
    SELECT 
        d.user_id,
        COUNT(s.sleep_date) AS dias_dormidos
    FROM (SELECT DISTINCT user_id FROM daily_activity) d
    LEFT JOIN sleep_day s 
        ON d.user_id = s.user_id
    GROUP BY d.user_id
)
SELECT 
    CASE 
        WHEN dias_dormidos >= 21 THEN '1. Dorme sempre com o aparelho (21 a 31 dias)'
        WHEN dias_dormidos BETWEEN 11 AND 20 THEN '2. Uso moderado no sono (11 a 20 dias)'
        WHEN dias_dormidos BETWEEN 1 AND 10 THEN '3. Raramente dorme com o aparelho (1 a 10 dias)'
        ELSE '4. Nunca regista o sono (0 dias)'
    END AS perfil_de_sono,
    COUNT(user_id) AS total_utilizadores,
    ROUND((COUNT(user_id) / (SELECT COUNT(DISTINCT user_id) FROM daily_activity)) * 100, 2) AS percentual_da_base_total
FROM consistencia_sono
GROUP BY 
    CASE 
        WHEN dias_dormidos >= 21 THEN '1. Dorme sempre com o aparelho (21 a 31 dias)'
        WHEN dias_dormidos BETWEEN 11 AND 20 THEN '2. Uso moderado no sono (11 a 20 dias)'
        WHEN dias_dormidos BETWEEN 1 AND 10 THEN '3. Raramente dorme com o aparelho (1 a 10 dias)'
        ELSE '4. Nunca regista o sono (0 dias)'
    END
ORDER BY perfil_de_sono;

-- ==============================================================================
-- Qual é o nível de adoção da funcionalidade de registo de peso? 
-- ==============================================================================
WITH consistencia_peso AS (
    SELECT 
        d.user_id,
        COUNT(w.log_id) AS dias_peso_registrado -- Pode usar LogId ou weight_date
    FROM (SELECT DISTINCT user_id FROM daily_activity) d
    LEFT JOIN weight_log w 
        ON d.user_id = w.user_id
    GROUP BY d.user_id
)
SELECT 
    CASE 
        WHEN dias_peso_registrado >= 15 THEN '1. Regista frequentemente (15+ dias)'
        WHEN dias_peso_registrado BETWEEN 1 AND 14 THEN '2. Regista esporadicamente (1 a 14 dias)'
        ELSE '3. Nunca regista o peso (0 dias)'
    END AS perfil_de_peso,
    COUNT(user_id) AS total_utilizadores,
    ROUND((COUNT(user_id) / (SELECT COUNT(DISTINCT user_id) FROM daily_activity)) * 100, 2) AS percentual_da_base_total
FROM consistencia_peso
GROUP BY 
    CASE 
        WHEN dias_peso_registrado >= 15 THEN '1. Regista frequentemente (15+ dias)'
        WHEN dias_peso_registrado BETWEEN 1 AND 14 THEN '2. Regista esporadicamente (1 a 14 dias)'
        ELSE '3. Nunca regista o peso (0 dias)'
    END
ORDER BY perfil_de_peso;

/* ==============================================================================
RESUMO EXECUTIVO DO SCRIPT 01 (INSIGHTS DE NEGÓCIO):

1. ALTA FIDELIDADE DIURNA E CONSISTÊNCIA: 
A amostra de 34 utilizadores apresenta um engajamento excecional para as atividades 
gerais. Cerca de 97% (33 utilizadores) usam o dispositivo quase todos os dias do mês, 
e mais de 88% da base utiliza o dispositivo no corpo pelo menos o dia todo (16h-23h) 
ou de forma contínua (~24h). Isso valida que o uso diurno já é um hábito consolidado.

2. A FRICÇÃO DO USO NOTURNO (SONO): 
Embora o uso diurno seja alto, a adoção da monitorização de sono despenca. Cerca de 
29,4% da base (10 utilizadores) nunca regista o sono (0 dias) e outros 26,4% registam 
raramente. Mais de metade da base rejeita ou tem dificuldade em manter o hábito noturno, 
o que indica um possível desconforto físico em dormir com o relógio no pulso. 
-> Oportunidade Bellabeat: Destacar o design ultraconfortável do Leaf para dormir.

3. A REJEIÇÃO AO INPUT MANUAL (PESO): 
A funcionalidade de peso tem uma taxa de rejeição massiva: quase 65% da base (22 utilizadores) 
nunca regista o peso. Dos poucos que utilizam, a esmagadora maioria sofre com o registo manual 
na app (is_manual_report = TRUE). A fricção de digitar os dados afasta o utilizador.
-> Oportunidade Bellabeat: Promover ecossistemas automatizados (como balanças conectadas) 
ou reposicionar o marketing exclusivamente nas métricas automáticas, que têm 97% de adesão.
============================================================================== */
