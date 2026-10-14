# Bellabeat Data Analysis

## Contexto do Projeto

A Bellabeat é uma empresa de tecnologia focada na criação de produtos inteligentes dedicados à saúde e ao bem-estar das mulheres. A empresa recolhe dados de atividade, sono, stresse e saúde reprodutiva para capacitar as utilizadoras com informações sobre os seus próprios hábitos.

Este projeto integra o estudo de caso do Certificado Profissional de Análise de Dados da Google. O objetivo principal consiste em analisar como os consumidores utilizam os seus dispositivos inteligentes no dia a dia e aplicar estas perspetivas para orientar as estratégias de marketing da Bellabeat.

## Perguntas de Negócio

A análise procura responder às seguintes questões centrais:

1. Quais são as principais tendências na utilização de dispositivos inteligentes?
2. Como é que essas tendências se podem aplicar aos clientes da Bellabeat?
3. Como é que essas tendências podem influenciar a estratégia de marketing da Bellabeat?

## Fonte dos Dados

Para responder a estas perguntas, é utilizado o conjunto de dados FitBit Fitness Tracker Data, um dataset público disponibilizado por Mobius no Kaggle. Este conjunto reúne registos de trinta utilizadores do Fitbit que autorizaram a partilha dos seus dados pessoais, incluindo atividade física, passos, frequência cardíaca e monitorização do sono.

Link do banco de dados: <https://www.kaggle.com/datasets/arashnic/fitbit>

## Status Atual do Projeto

**Fase Atual:** Preparação e Limpeza de Dados (Camada Silver).

- [x] Configuração do ambiente isolado e estrutura profissional de diretórios.
- [x] Criação do módulo `data_loader` para automação de leitura e varredura de arquivos.
- [x] Inventário, amostragem e seleção de tabelas analíticas (`dailyActivity`, `sleepDay`, `hourlySteps`, `weightLogInfo`).
- [x] Ingestão e concatenação de dados brutos (Pipeline da Camada Bronze concluída).
- [ ] Limpeza, tratamento de tipos de dados (datas) e deduplicação (Notebook 02).
- [ ] Carga no Banco de Dados e Exploração via SQL.
- [ ] Desenvolvimento de Dashboards/Visualizações.

## Arquitetura do Projeto

```text
bellabeat_data_analysis/
│
├── .venv/
├── .env
├── .gitignore
├── README.md
├── requirements.txt
│
├── data/
│   ├── raw/                # Arquivos CSV originais divididos por mês
│   └── processed/          # Arquivos concatenados e limpos (ex: *_concat.csv)
│
├── notebooks/
│   ├── 01_concatenation_and_profiling.ipynb   # Inventário exploratório e pipeline de ingestão
│   └── 02_data_cleaning.ipynb                 # Limpeza de dados
│
├── sql/
│   
├── dashboards/
│
└── src/
    ├── __init__.py
    └── data_loader.py      # Módulos Python com funções reutilizáveis de ETL
```
