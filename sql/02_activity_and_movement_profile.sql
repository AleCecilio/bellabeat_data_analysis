-- ==============================================================================
--ARQUIVO: 02_activity_and_movement_profile.sql
-- OBJETIVO: Mapear o perfil físico 
-- ==============================================================================

-- ==============================================================================
-- Como se movem?
-- ==============================================================================
SELECT
    ROUND(AVG(total_steps),2) AS media_de_passos,
    ROUND(AVG(total_distance),2) AS distancia_media,
    ROUND(AVG(calories),2) AS gasto_calorico_medio,
    ROUND(AVG((
        very_active_minutes + 
        fairly_active_minutes + 
        lightly_active_minutes) / 60
    ),2) AS media_horas_ativas,
    ROUND(AVG(sedentary_minutes) / 60,2) AS media_horas_sedentarias
FROM daily_activity;


-- ==============================================================================
-- Qual a distribuição de usuarias em relação ao volume de tempo de atividade?
-- ==============================================================================
WITH usuario_por_tempo_atividade AS (
    SELECT 
        user_id,
        SUM(very_active_minutes) AS min_totais_muito_ativo,
        SUM(fairly_active_minutes) AS min_totais_moderadamente_ativo,
        SUM(lightly_active_minutes) AS min_totais_levemente_ativo,
        SUM(sedentary_minutes) AS min_totais_sedentario,
        SUM(
            very_active_minutes + 
            fairly_active_minutes + 
            lightly_active_minutes
        ) AS tempo_total_ativo
    FROM daily_activity
    GROUP BY user_id
)
SELECT 
    CASE
        WHEN tempo_total_ativo <= (min_totais_sedentario * 0.15) 
            THEN '4. Perfil Sedentário (Quase zero movimento)'
        WHEN min_totais_muito_ativo >= (tempo_total_ativo * 0.10) 
            THEN '1. Perfil Atleta (Treinos de Alta Intensidade)'
        WHEN min_totais_moderadamente_ativo >= (tempo_total_ativo * 0.10) 
            THEN '2. Perfil Ativo (Treinos Moderados)'
        ELSE '3. Perfil Rotineiro (Apenas Movimento Leve/Caminhadas)'
    END AS perfil_de_intensidade,
    COUNT(user_id) AS total_utilizadores,
    ROUND(
        (
            COUNT(user_id) / 
            (SELECT COUNT(DISTINCT user_id) FROM daily_activity)
        ) * 100, 2
    ) AS percentual_da_base
FROM usuario_por_tempo_atividade
GROUP BY 
    CASE
        WHEN tempo_total_ativo <= (min_totais_sedentario * 0.15) 
            THEN '4. Perfil Sedentário (Quase zero movimento)'
        WHEN min_totais_muito_ativo >= (tempo_total_ativo * 0.10) 
            THEN '1. Perfil Atleta (Treinos de Alta Intensidade)'
        WHEN min_totais_moderadamente_ativo >= (tempo_total_ativo * 0.10) 
            THEN '2. Perfil Ativo (Treinos Moderados)'
        ELSE '3. Perfil Rotineiro (Apenas Movimento Leve/Caminhadas)'
    END
ORDER BY perfil_de_intensidade;


-- ==============================================================================
-- Qual a distribuição de usuarias em relação ao volume de passos por dia?
-- ==============================================================================

WITH media_passos_usuario AS (
    SELECT 
        user_id,
        AVG(total_steps) AS media_diaria_passos
    FROM daily_activity
    GROUP BY user_id
)
SELECT 
    CASE
        WHEN media_diaria_passos >= 10000 
            THEN '1. Muito Ativo (10k+ passos)'   
        WHEN media_diaria_passos >= 7500 
            THEN '2. Moderado (7.5k - 9.9k passos)'  
        WHEN media_diaria_passos >= 5000 
            THEN '3. Levemente Ativo (5k - 7.4k passos)'
        ELSE '4. Sedentário (< 5k passos)'
    END AS perfil_de_volume_fisico, 
    COUNT(user_id) AS total_utilizadores,
    ROUND(
        (
            COUNT(user_id) / 
            (SELECT COUNT(DISTINCT user_id) FROM daily_activity)
        ) * 100, 2
    ) AS percentual_da_base
FROM media_passos_usuario
GROUP BY 
    CASE
        WHEN media_diaria_passos >= 10000 
            THEN '1. Muito Ativo (10k+ passos)' 
        WHEN media_diaria_passos >= 7500 
            THEN '2. Moderado (7.5k - 9.9k passos)'
        WHEN media_diaria_passos >= 5000 
            THEN '3. Levemente Ativo (5k - 7.4k passos)'
        ELSE '4. Sedentário (< 5k passos)'
    END
ORDER BY perfil_de_volume_fisico;

-- ==============================================================================
-- Qual a media de passos por hora e periodo do dia?
-- ==============================================================================

SELECT 
    hour_of_day,
    ROUND(AVG(step_total), 2) AS media_de_passos
FROM hourly_steps
GROUP BY hour_of_day
ORDER BY media_de_passos DESC;


SELECT 
    day_period,
    ROUND(AVG(step_total), 2) AS media_de_passos
FROM hourly_steps
GROUP BY day_period
ORDER BY media_de_passos DESC;

-- ==============================================================================
-- Qual o impacto da intensidade da atividade na queima calórica diária?
-- ==============================================================================
SELECT 
    CASE
        -- O padrão médico (OMS) considera 30 min como um treino válido
        WHEN very_active_minutes >= 30 
            THEN '1. Dia com Treino Intenso (30+ min)'
        WHEN fairly_active_minutes >= 30 
            THEN '2. Dia com Treino Moderado (30+ min)'
        WHEN lightly_active_minutes >= 150 
            THEN '3. Dia de Movimento Leve (150+ min)'
            
        ELSE '4. Dia Maioritariamente Sedentário'
    END AS tipo_de_dia_fisico,
    ROUND(AVG(calories), 0) AS media_calorias_queimadas,
    COUNT(*) AS volume_de_dias_avaliados
FROM daily_activity
WHERE total_steps > 0 
GROUP BY 
    CASE
        WHEN very_active_minutes >= 30 
            THEN '1. Dia com Treino Intenso (30+ min)'
        WHEN fairly_active_minutes >= 30 
            THEN '2. Dia com Treino Moderado (30+ min)'
        WHEN lightly_active_minutes >= 150 
            THEN '3. Dia de Movimento Leve (150+ min)'
        ELSE '4. Dia Maioritariamente Sedentário'
    END
ORDER BY tipo_de_dia_fisico;

-- ==============================================================================
-- Exitem dias onde os usuario andam menos e têm mais atividades sedentarias?
-- ==============================================================================
SELECT 
    day_of_week,
    ROUND(AVG(very_active_minutes), 2) AS media_min_muito_ativos,
    ROUND(AVG(fairly_active_minutes), 2) AS media_min_moderadamente_ativos,
    ROUND(AVG(lightly_active_minutes), 2) AS media_min_levemente_ativos,
    ROUND(AVG(sedentary_minutes), 2) AS media_min_sedentarios,
    ROUND(AVG(total_steps), 2) AS media_passos
FROM daily_activity
GROUP BY day_of_week
ORDER BY media_passos DESC;

/* ==============================================================================
RESUMO EXECUTIVO DO SCRIPT 02 (PERFIL DE ATIVIDADE E MOVIMENTO):

1. O PARADOXO DO MOVIMENTO (VOLUME VS. INTENSIDADE):
A base de clientes apresenta um bom volume de passos (50% dá mais de 7.500 passos/dia), 
mas a intensidade desse movimento é baixa. Cerca de 47% das usuárias enquadram-se no 
"Perfil Rotineiro", o que indica que atingem o seu volume de passos através da 
movimentação orgânica diária (trabalho/casa) e não através de treinos focados.
-> Insight Bellabeat: A comunicação não deve ter um tom de "alta performance 
desportiva". O foco deve ser o bem-estar diário e a celebração do movimento rotineiro.

2. A OPORTUNIDADE DO "ESFORÇO VS. RECOMPENSA":
A análise diária prova matematicamente a eficiência do treino. Dias com apenas 30 
minutos de atividade intensa queimam, em média, 2.842 calorias. Em contraste, dias 
de movimento leve (mesmo durando mais de 2h30) queimam apenas 2.208 calorias.
-> Insight Bellabeat: A App pode usar este dado para incentivar treinos curtos. 
Mensagem sugerida: "Apenas 30 minutos de treino intenso queimam 28% mais calorias 
do que um dia inteiro de caminhada leve."

3. A ROTINA DA "MULHER TRABALHADORA" (PICOS HORÁRIOS):
Os picos de atividade ocorrem na Tarde (média de 484 passos/hora), especificamente 
às 12h-14h (almoço) e 17h-19h (fim do expediente). As manhãs (antes das 8h) têm baixa 
atividade, contrariando o mito do "treino matinal". Os dias com maior sedentarismo 
e menor volume de passos são o Domingo e a Sexta-feira.
-> Insight Bellabeat: As notificações push do telemóvel para encorajar o movimento 
devem ser enviadas perto da hora de almoço ou ao fim do dia. Ao Domingo, as 
notificações de treino devem ser substituídas por lembretes de descanso e meditação.
============================================================================== */