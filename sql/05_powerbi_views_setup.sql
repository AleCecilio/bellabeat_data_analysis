-- ==============================================================================   
-- ARQUIVO: 05_semantic_layer_powerbi.sql
-- OBJETIVO: Criar as views (camada semântica) para consumo no dashboard do Power BI.
-- ==============================================================================

-- ==============================================================================
--  Fricção de Uso e Retenção de Funcionalidades (Funil)
-- OBJETIVO: Contabilizar a queda de usuários ativos em cada nível de 
--           engajamento, desde a base total até o registro de peso, 
--           para alimentar o gráfico de funil no Power BI.
-- ==============================================================================
CREATE OR REPLACE VIEW vw_funil_friccao AS
SELECT 
    'Atividade Diária' AS etapa_do_funil, 
    COUNT(DISTINCT user_id) AS total_utilizadores
FROM daily_activity
UNION ALL
SELECT 
    'Passos por Hora' AS etapa_do_funil, 
    COUNT(DISTINCT user_id) 
FROM hourly_steps
UNION ALL
SELECT 
    'Sono Diário' AS etapa_do_funil, 
    COUNT(DISTINCT user_id) 
FROM sleep_day
UNION ALL
SELECT 
    'Registo de Peso' AS etapa_do_funil, 
    COUNT(DISTINCT user_id) 
FROM weight_log;

-- ==============================================================================
-- Perfil de Engajamento e Uso Diário (Ref. Script 01)
-- ==============================================================================
CREATE OR REPLACE VIEW vw_dim_perfil_engajamento AS
WITH uso_por_utilizador AS (
    SELECT 
        u.user_id,
        COUNT(a.activity_date) AS dias_de_uso,
        COALESCE(AVG(
            (
                a.very_active_minutes + 
                a.fairly_active_minutes + 
                a.lightly_active_minutes + 
                a.sedentary_minutes
            ) / 60
        ), 0) AS media_horas_uso_diario
    FROM dim_users u
    LEFT JOIN daily_activity a 
        ON u.user_id = a.user_id
    GROUP BY u.user_id
)
SELECT 
    user_id,
    CASE 
        WHEN dias_de_uso >= 21 
            THEN 'Uso Assíduo (21 a 31 dias)'
        WHEN dias_de_uso BETWEEN 11 AND 20 
            THEN 'Uso Moderado (11 a 20 dias)'
        ELSE 'Uso Esporádico (1 a 10 dias)'
    END AS categoria_de_uso,
    CASE
        WHEN ROUND(media_horas_uso_diario, 1) >= 23.5 
            THEN 'Uso Contínuo (~24h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 16 
            THEN 'Uso Diário Alto (16h - 23h)'
        WHEN ROUND(media_horas_uso_diario, 1) >= 8 
            THEN 'Uso Parcial (8h - 15h)'
        ELSE 'Uso Pontual (< 8h)'
    END AS padrao_de_uso
FROM uso_por_utilizador;

-- ==============================================================================
-- Perfil de Atividade e Movimento (Ref. Script 02)
-- ==============================================================================
CREATE OR REPLACE VIEW vw_dim_perfil_atividade AS
WITH atividade_por_usuario AS (
    SELECT 
        u.user_id,
        AVG(a.total_steps) AS media_diaria_passos,
        SUM(a.very_active_minutes) AS min_totais_muito_ativo,
        SUM(a.fairly_active_minutes) AS min_totais_moderadamente_ativo,
        SUM(a.lightly_active_minutes) AS min_totais_levemente_ativo,
        SUM(a.sedentary_minutes) AS min_totais_sedentario,
        SUM(
            a.very_active_minutes + 
            a.fairly_active_minutes + 
            a.lightly_active_minutes
        ) AS tempo_total_ativo
    FROM dim_users u
    LEFT JOIN daily_activity a 
        ON u.user_id = a.user_id
    GROUP BY u.user_id
)
SELECT 
    user_id,
    CASE
        WHEN tempo_total_ativo <= (min_totais_sedentario * 0.15) 
            THEN 'Perfil Sedentário (Quase zero movimento)'
        WHEN min_totais_muito_ativo >= (tempo_total_ativo * 0.10) 
            THEN 'Perfil Atleta (Treinos de Alta Intensidade)'
        WHEN min_totais_moderadamente_ativo >= (tempo_total_ativo * 0.10) 
            THEN 'Perfil Ativo (Treinos Moderados)'
        ELSE 'Perfil Rotineiro (Apenas Movimento Leve/Caminhadas)'
    END AS perfil_de_intensidade,
    CASE
        WHEN media_diaria_passos >= 10000 
            THEN 'Muito Ativo (10k+ passos)'    
        WHEN media_diaria_passos >= 7500 
            THEN 'Moderado (7.5k - 9.9k passos)'  
        WHEN media_diaria_passos >= 5000 
            THEN 'Levemente Ativo (5k - 7.4k passos)'
        ELSE '4. Sedentário (< 5k passos)'
    END AS perfil_de_volume_fisico
FROM atividade_por_usuario;

-- ==============================================================================
-- Perfil de Qualidade do Sono (Ref. Script 03)
-- ==============================================================================
CREATE OR REPLACE VIEW vw_dim_perfil_sono AS
WITH media_de_sono AS (
    SELECT
        u.user_id,
        ROUND(AVG(s.total_minutes_asleep) / 60, 2) AS tempo_medio_sono
    FROM dim_users u
    LEFT JOIN sleep_day s 
        ON u.user_id = s.user_id
    GROUP BY u.user_id
)
SELECT
    user_id,
    CASE
        WHEN tempo_medio_sono IS NULL 
            THEN 'Não Registra Sono'
        WHEN tempo_medio_sono < 7
            THEN 'Sono Insuficiente'
        WHEN tempo_medio_sono <= 9
            THEN 'Sono Ideal'
        ELSE 'Sono Acima Do Normal'
    END AS perfil_de_sono
FROM media_de_sono;

-- ==============================================================================
-- Perfil Biométrico e Registro de Peso (Ref. Script 01 e 04)
-- ==============================================================================
CREATE OR REPLACE VIEW vw_dim_perfil_peso AS
WITH peso_por_usuario AS (
    SELECT
        u.user_id,
        COUNT(w.log_id) AS dias_peso_registrado,
        AVG(w.weight_kg) AS peso_medio,
        AVG(w.bmi) AS imc_medio
    FROM dim_users u
    LEFT JOIN weight_log w 
        ON u.user_id = w.user_id
    GROUP BY u.user_id
)
SELECT
    user_id,
    CASE 
        WHEN dias_peso_registrado >= 15 
            THEN 'Regista frequentemente (15+ dias)'
        WHEN dias_peso_registrado BETWEEN 1 AND 14 
            THEN 'Regista esporadicamente (1 a 14 dias)'
        ELSE 'Nunca regista o peso (0 dias)'
    END AS perfil_de_peso,
    ROUND(peso_medio, 2) AS media_peso_kg,
    ROUND(imc_medio, 2) AS media_bmi
FROM peso_por_usuario;