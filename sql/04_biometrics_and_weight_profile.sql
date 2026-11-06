-- ==============================================================================   
-- ARQUIVO: 04_biometrics_and_weight_profile.sql
-- OBJETIVO: Entender quem é o "Power User" que registra peso.
-- ==============================================================================

-- ==============================================================================
-- Como estão fisicamente os usuários que regitram seus pesos?
-- ==============================================================================
SELECT
    COUNT(DISTINCT(u.user_id)) AS total_utilizadores
FROM dim_users u
INNER JOIN weight_log w 
    ON u.user_id = w.user_id;


SELECT
    ROUND(AVG(weight_kg),2) AS media_peso_kg,
    ROUND(AVG(bmi),2) AS media_imc
FROM weight_log;


-- ==============================================================================
-- Qual o tipo de perfil que registra peso?
-- ==============================================================================

WITH atividade_por_usuario AS (
    SELECT
        u.user_id,
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
    INNER JOIN daily_activity a 
        ON u.user_id = a.user_id 
    GROUP BY u.user_id
),
peso_por_usuario AS (
    SELECT
        u.user_id,
        AVG(w.weight_kg) AS peso_medio,
        AVG(w.bmi) AS imc_medio
    FROM dim_users u
    INNER JOIN weight_log w 
        ON u.user_id = w.user_id
    GROUP BY u.user_id
),
classificacao AS (
    SELECT
        a.user_id,
        CASE
            WHEN a.tempo_total_ativo <= a.min_totais_sedentario * 0.15
                THEN '4. Perfil Sedentário (Quase zero movimento)'
            WHEN a.min_totais_muito_ativo >= a.tempo_total_ativo * 0.10
                THEN '1. Perfil Atleta (Treinos de Alta Intensidade)'
            WHEN a.min_totais_moderadamente_ativo >= a.tempo_total_ativo * 0.10
                THEN '2. Perfil Ativo (Treinos Moderados)'
            ELSE '3. Perfil Rotineiro (Apenas Movimento Leve/Caminhadas)'
        END AS perfil_de_intensidade,
        p.peso_medio,
        p.imc_medio
    FROM atividade_por_usuario a
    INNER JOIN peso_por_usuario p
        ON a.user_id = p.user_id
)
SELECT
    perfil_de_intensidade,
    COUNT(DISTINCT(user_id)) AS total_utilizadores,
    ROUND(AVG(peso_medio), 2) AS media_peso_kg,
    ROUND(AVG(imc_medio), 2) AS media_bmi
FROM classificacao
GROUP BY perfil_de_intensidade
ORDER BY perfil_de_intensidade;


/* ==============================================================================
RESUMO: SCRIPT 03 (PERFIL DE USUÁRIOS QUE REGISTRAM SEU PESO):

OBSERVAÇÃO: Essa tabela possui uma baixa amostragem como comentado no script 01,
isso reduz a capacidade de análise, e essa tabela não é uma boa base de dados para 
nosso negócio, na verdade o fato de poucas pessoas a utilizarem para registrar seus pesos
é o mais interessante, principalmente para melhorar e crias novos produtos no futuro. 
Entretanto como o projeto pede o insight direcionado para UM dispositivo esse script fica
apenas como um suporte interessante e um adendo para as proxímas fases da Bellabeat.

1. SOBREPESO COMO MAIORIA:
Observa-se que a média geral de IMC (BMI) é de 25.37, levemte aciama
do recomenda para adultos, de 18,5 e 24,9, repesentando um média de indivíduos com
sobrepeso na amaostra.

2. OS REGISTROS DE PESO SÃO EM MÉIDA DE PESSOAS SOBREPESAS:
Como já havia sido constatado na primeira consulta os indivíduos são em sua maioria
sobrepesos, mas constata-se também que 7 em 12 dos que registraram seu peso possuem 
em média um IMC (BMI) de 26.59, sendo eles a maioria esmagadora da amostra e
classificados dentro do perfil rotineiro. Além disso 2 pessoas eão em Obesidade
Grau II com uma média de 103 kg e um IMC de 38.2, e classificados como sendentários,
o mesmo número de utilizadores são atletas com peso de 76 e IMC de 25.

-> Insight Bellabeat: O publico alvo não é de atletas e sim de pessoas em estado de 
sobrepeso ou superior. Isso revela que os usuários não estaram fazendo os registros de 
peso por performace e sim por objetivos com foco em saúde. Com isso em evidência a 
automatização, sugerida no script 01, se torna mais necessária para facilitar o processo, 
além de ser importante tomar cuidade com os insight do app para o usuário, evitar cobranças
ecesseivas e incentivar ativiades leves com foco em queima calorica e saúde. 

============================================================================== */