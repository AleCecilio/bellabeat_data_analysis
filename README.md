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

## Arquitetura do Projeto

```text
bellabeat_data_analysis/
├── data/
│   ├── raw/                # Arquivos CSV originais divididos por mês
│   └── processed/          # Arquivos concatenados e limpos
│
├── notebooks/
│   ├── 01_concatenation_and_profiling.ipynb  # Inventário exploratório e ingestão
│   └── 02_data_cleaning.ipynb                # Limpeza de dados
│
├── sql/                    # Consultas SQL para análise de dados
│
├── dashboards/             # Dashboards e arquivos relacionados
│
├── src/                    # Módulos Python com funções reutilizáveis
│   ├── __init__.py
│   ├── io/
│   │   ├── __init__.py
│   │   └── data_loader.py
│   ├── utils/
│   │   ├── __init__.py
│   │   └── data_quality.py
│   └── plots/
│       ├── __init__.py
│       └── graph_data_quality.py
│
├── .gitignore
├── README.md
└── requirements.txt

## Descobertas e Direcionamento Estratégico (Insights)

Através da exploração de dados via SQL, foram identificadas fraquezas estruturais no uso de *smartwatches* desportivos tradicionais (concorrência). Para capitalizar sobre estas deficiências, a estratégia de negócio deste projeto foca-se exclusivamente num produto: o **Bellabeat Leaf**. O Leaf é um monitor de bem-estar clássico que pode ser usado como pulseira, colar ou clipe.

A decisão baseia-se nos seguintes *insights* extraídos da base de dados:

* **A Fricção do Uso Noturno (Solução de Conforto):** A análise revelou que mais de 55% da base rejeita ou tem dificuldade em manter a monitorização do sono (29,4% nunca regista; 26,4% regista raramente). Isto indica um desconforto físico em dormir com um relógio emborrachado no pulso. Sendo o Leaf versátil ao ponto de poder ser usado como um clipe na roupa, ele elimina esta fricção de usabilidade noturna, garantindo uma recolha de dados contínua e confortável.
* **O Paradoxo do Movimento (Design para a Mulher Trabalhadora):** Os dados mostram que 47% das utilizadoras se enquadram num "Perfil Rotineiro". Atingem um alto volume de passos diários através da movimentação orgânica em horários comerciais (deslocamentos e horário de almoço), e não em ginásios. Como o Leaf se assemelha a uma peça de joalharia, ele resolve a dor de usar um acessório desportivo que não combina com o ambiente corporativo ou eventos sociais.
* **Rejeição ao *Input* Manual (A Lição da Tabela de Peso):** A análise de biometria revelou uma rejeição massiva à inserção manual de dados (quase 65% nunca regista o peso). Embora a baixa amostragem desta métrica limite a análise estatística, ela gera uma forte conclusão de UX (*User Experience*): a recolha de dados tem de ser invisível e automática. Esta descoberta reforça a premissa de que o *hardware* da Bellabeat (como o Leaf) deve fazer o trabalho pesado de forma passiva, mitigando o abandono de funcionalidades por parte do utilizador.

## Recomendações de Medidas Futuras

Embora o foco primário de marketing seja o hardware (Leaf), a análise levantou oportunidades claras para a evolução a longo prazo do ecossistema Bellabeat:

* **Otimização de Notificações na App:** Implementar alertas de encorajamento ao movimento baseados nos picos horários reais das utilizadoras (especificamente entre as 12h-14h e 17h-19h). Adicionalmente, tendo em vista as dificuldades de sono registadas, a App pode enviar notificações suaves no período noturno sugerindo a redução de estímulos (como evitar telas) e rituais de relaxamento.
* **Criação de uma Balança Inteligente (Automação):** Visto que o público-alvo revelou ser composto maioritariamente por pessoas com sobrepeso com foco em saúde (e não atletas de alta performance), o acompanhamento do peso é crucial. No entanto, o registo manual gera abandono. O desenvolvimento de uma balança conectada e automática preencheria uma lacuna essencial no portfólio da marca, garantindo fidelização e precisão nos dados biométricos sem exigir esforço extra da utilizadora.

## Status Atual do Projeto

**Fase Atual:** Preparação e Limpeza de Dados (Camada Silver).

- [x] Configuração do ambiente isolado e estrutura profissional de diretórios.
- [x] Criação do módulo `data_loader` para automação de leitura e varredura de arquivos.
- [x] Inventário, amostragem e seleção de tabelas analíticas (`dailyActivity`, `sleepDay`, `hourlySteps`, `weightLogInfo`).
- [x] Ingestão e concatenação de dados brutos (Pipeline da Camada Bronze concluída).
- [x] Limpeza, tratamento de tipos de dados (datas) e deduplicação (Notebook 02).
- [x ] Carga no Banco de Dados e Exploração via SQL.
- [ ] Desenvolvimento de Dashboards/Visualizações.
