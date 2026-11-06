-- ==============================================================================   
-- ARQUIVO: 03_sleep_and_rest_profile.sql
-- OBJETIVO: Analisar a qualidade do descanso.
-- ==============================================================================

-- ==============================================================================
-- Como o tempo na cama é utilizado?
-- ==============================================================================

SELECT 
    ROUND(AVG(total_sleep_records), 2) AS media_total_sonos,
    ROUND((AVG(total_time_in_bed)/60), 2) AS tempo_medio_cama,
    ROUND((AVG(total_minutes_asleep)/60), 2) AS tempo_medio_sono,
    ROUND((AVG(minutes_awake_in_bed)/60), 2) AS tempo_medio_acordado_na_cama
FROM sleep_day;

-- ==============================================================================
-- Qual a distribuição de usuarios por tempo de sono?
-- ==============================================================================
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
    CASE
        WHEN tempo_medio_sono < 7
            THEN '1. SONO INSUFICIENTE'
        WHEN tempo_medio_sono <= 9
            THEN '2. SONO IDEAL'
        ELSE '3. SONO ACIMA DO NORMAL'
    END AS perfil_de_sono,
    COUNT(user_id) AS total_de_usuarios,
    ROUND(
        (
            COUNT(user_id) /
            (SELECT COUNT(DISTINCT user_id) FROM dim_users) 
        )* 100, 2
    ) AS percentual_por_categoria
FROM media_de_sono
GROUP BY
    CASE
        WHEN tempo_medio_sono < 7
            THEN '1. SONO INSUFICIENTE'
        WHEN tempo_medio_sono <= 9
            THEN '2. SONO IDEAL'
        ELSE '3. SONO ACIMA DO NORMAL'
    END
ORDER BY perfil_de_sono;


-- ==============================================================================
-- Qual a média de tempo de sono nos dias da semana?
-- ==============================================================================


SELECT 
    c.day_name AS dia_semana,
    ROUND(AVG(s.total_minutes_asleep) / 60,2) AS tempo_medio_sono,
    ROUND((
        (AVG(s.total_minutes_asleep)) / 
        SUM(AVG(s.total_minutes_asleep)) OVER()
    ) * 100, 2) AS percentual_sono_dia
FROM sleep_day s
JOIN dim_calendar c 
    ON s.sleep_date = c.full_date
GROUP BY c.day_name
ORDER BY tempo_medio_sono;

/* ==============================================================================
RESUMO: SCRIPT 03 (PERFIL DE SONO):

1.DEMORA PARA DORMIR:
A amostra registra que os usuários usam em dormem em média 6.99 minutos, enquanto 
passam ficam acordados na cama o por 0.66 minutos. Isso demonstra um desequilibrio,
se o periodo acordado fosse menor, os usuários se aproximariam mais do sono ideal.

2. ALTO NÚMERO DE USUÁRIOS COM SONO INSUFICIENTE:
Obrserva-se que 13 dos utilizadores se enquadão na categória de sono insuficiente, 
representando 54% da amostra. Enquanto outros 10, 42%, possuem sono ideal e apenas 1 
dorme mais do que o normal. Com isso, é interesante destacar a necessidade de
normalizar o sono dos 13 indivíduos com horas de sono abaixo do ideal.

3.  REPOSIÇÃO DE SONO:
Os registros apontam que por a Domingo é o dia em que as pessoas mais dormem
com 15% do tempo médio de sono semanal, entretanto dias como Quarta, Segunda
e Sábado não se destanciam tando, todos com 14%, já os demais ficam na casa do 13%.
Tal fato constata, um almento do tempo de sono no Domingo, podendo apontar para 
uma tentativa de reposição de sono por parte dos usuários.

-> Insight Bellabeat: Notificações proxímas da hora de dormir, avisando os indivíduos
que seria um bom momento para diminuir estimulos e se preparar para sono, sugerindo dicas,
como o habito da leitura, não utilizar telas, hidratação e demais ritos noturno.

============================================================================== */