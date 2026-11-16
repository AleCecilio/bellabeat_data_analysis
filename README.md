# Bellabeat: Análise de Engajamento e Retenção de Usuários

### Onde os usuários abandonam o produto: uso passivo, sono e registro manual de peso

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)

![Status](https://img.shields.io/badge/status-conclu%C3%ADdo-blue?style=for-the-badge)
![Tipo](https://img.shields.io/badge/tipo-portf%C3%B3lio-blueviolet?style=for-the-badge)
![Origem](https://img.shields.io/badge/origem-Google_Data_Analytics-4285F4?style=for-the-badge&logo=google&logoColor=white)

[![Dashboard online](https://img.shields.io/badge/Dashboard-Power_BI_Web-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://app.powerbi.com/view?r=eyJrIjoiMGQ0YWU4MWMtYmQyMi00MzNlLTg2YzYtZTVlYmYxOTYwMzJlIiwidCI6IjU1ZWRkMDA3LTY2ZTItNDllOS1iZWM3LWU1YWIxYzFiYWMyNiJ9)

---

## Sobre o Projeto

Este projeto é o Estudo de Caso II da certificação Google Data Analytics. O cenário é o da Bellabeat, fabricante de dispositivos vestíveis e de um aplicativo de bem-estar voltados para mulheres, e a pergunta central é: **em que pontos os usuários deixam de usar o produto e o que isso revela sobre engajamento e retenção?**

A análise parte de dados de dispositivos vestíveis de 35 usuários ao longo de 62 dias e percorre o ciclo completo: preparação e tratamento dos dados com Python e SQL, segmentação dos usuários e um dashboard interativo de três páginas no Power BI, com identidade visual e navegação projetadas no Figma. O resultado é um conjunto de conclusões sobre onde o produto retém e onde perde o usuário, com recomendações para a Bellabeat.

<p align="center">
  <a href="https://app.powerbi.com/view?r=eyJrIjoiMGQ0YWU4MWMtYmQyMi00MzNlLTg2YzYtZTVlYmYxOTYwMzJlIiwidCI6IjU1ZWRkMDA3LTY2ZTItNDllOS1iZWM3LWU1YWIxYzFiYWMyNiJ9">
    <img src="dashbord/Gifs/Adobe Express - Gravando 2026-11-16 101834.gif" alt="Capa do dashboard Bellabeat com menu de páginas analíticas" width="85%">
  </a>
</p>
<p align="center"><sub>Capa do dashboard e menu de navegação entre as páginas analíticas. Clique para abrir a versão interativa.</sub></p>

---

## Objetivos

| Etapa | Descrição | Status |
| --- | --- | --- |
| Entendimento do negócio | Definição da pergunta de engajamento e retenção e das métricas associadas | Concluído |
| Preparação | Seleção das tabelas de atividade, passos por hora, sono e peso | Concluído |
| Tratamento | Limpeza, padronização e validação dos dados | Concluído |
| Segmentação | Classificação dos usuários por horas de uso, consistência de sono, consistência de peso e perfil de atividade | Concluído |
| Dashboard | Dashboard interativo no Power BI (3 páginas, menu lateral e painel de filtros) | Concluído |
| Design | Capa, navegação e identidade visual no Figma | Concluído |
| Conclusões | Achados, limitações e recomendações para a Bellabeat | Concluído |

---

## Sumário

- [Bellabeat: Análise de Engajamento e Retenção de Usuários](#bellabeat-análise-de-engajamento-e-retenção-de-usuários)
    - [Onde os usuários abandonam o produto: uso passivo, sono e registro manual de peso](#onde-os-usuários-abandonam-o-produto-uso-passivo-sono-e-registro-manual-de-peso)
  - [Sobre o Projeto](#sobre-o-projeto)
  - [Objetivos](#objetivos)
  - [Sumário](#sumário)
  - [Perguntas de negócio](#perguntas-de-negócio)
  - [Fluxo do projeto](#fluxo-do-projeto)
  - [Dados](#dados)
  - [Tecnologias](#tecnologias)
  - [Estrutura do repositório](#estrutura-do-repositório)
  - [Processo analítico](#processo-analítico)
    - [Lógica de análise](#lógica-de-análise)
  - [Principais resultados](#principais-resultados)
    - [Uso e retenção](#uso-e-retenção)
    - [Perfil físico](#perfil-físico)
    - [Sono](#sono)
  - [Dashboard](#dashboard)
    - [Navegação](#navegação)
    - [Filtros](#filtros)
  - [Conclusões gerais](#conclusões-gerais)
  - [Recomendações para a Bellabeat](#recomendações-para-a-bellabeat)
  - [Limitações](#limitações)
  - [Como explorar o projeto](#como-explorar-o-projeto)
  - [Possíveis melhorias](#possíveis-melhorias)
  - [Autor](#autor)

---

## Perguntas de negócio

| # | Pergunta | Onde é respondida |
| --- | --- | --- |
| 1 | Quantos usuários utilizam cada funcionalidade do produto? | Perfil de Uso |
| 2 | Por quantas horas por dia o dispositivo fica de fato no corpo? | Perfil de Uso |
| 3 | Qual a consistência do registro de sono e de peso? | Perfil de Uso e Perfil de Sono |
| 4 | Que perfis de rotina existem e em quais horários o movimento se concentra? | Perfil Físico |
| 5 | Quem registra o peso e por que a funcionalidade é abandonada? | Perfil Físico |
| 6 | Qual a duração, a qualidade e a eficiência do sono? | Perfil de Sono |
| 7 | Que ações de produto os achados sustentam? | Conclusões e Recomendações |

---

## Fluxo do projeto

```text
Tabelas do dataset (CSV)  ->  Python  ->  Exploração e tratamento  ->  Dados tratados
                                                                           |
                      Power BI  <-  Segmentações e medidas  <-  Consultas SQL
                         |
                      Figma (capa, navegação e identidade visual)
```

---

## Dados

**Fonte:** FitBit Fitness Tracker Data (Kaggle, domínio público), com registros de usuários que consentiram em compartilhar dados de dispositivos vestíveis. Os dados não são da Bellabeat; servem como referência de uso de dispositivos semelhantes.

**Período:** 62 dias, de março a maio de 2016 (12/03/2016 a 12/05/2016).

**Tabelas utilizadas:**

| Tabela | Conteúdo | Usuários únicos | Cobertura sobre a base |
| --- | --- | ---: | ---: |
| Atividade Diária | Passos, distância, calorias e minutos por intensidade | 34 | 97,14% |
| Passos por Hora | Passos registrados hora a hora | 34 | 97,14% |
| Sono Diário | Minutos dormidos e tempo na cama | 24 | 68,57% |
| Registro de Peso | Peso e IMC informados | 12 | 34,29% |

**Base total:** 35 usuários.

**Segmentações criadas na análise:**

| Segmentação | Categorias |
| --- | --- |
| Horas com o aparelho no corpo | Uso Contínuo (~24h), Uso Diário Alto (16h a 23h), Uso Parcial (8h a 15h), Uso Pontual (menos de 8h) |
| Consistência de sono | Sono Ideal, Sono Insuficiente, Sono Acima do Normal, Não Registra Sono |
| Consistência de peso | Nunca registra (0 dias), Registra esporadicamente (1 a 14 dias), Registra com frequência (15 dias ou mais) |
| Perfil de volume e intensidade | Rotineiro (apenas movimento leve ou caminhadas), Atleta (treinos de alta intensidade), Sedentário (quase zero movimento), Ativo (treinos moderados) |

---

## Tecnologias

| Ferramenta | Uso no projeto |
| --- | --- |
| Python | Exploração, tratamento e validação dos dados |
| SQL | Consultas de agregação e segmentação dos usuários |
| Power BI | Modelagem, medidas e dashboard interativo de três páginas |
| Figma | Capa, menu lateral, ícones e identidade visual do dashboard |

---

## Estrutura do repositório

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
```

**Observações:**
- `dashbord/` e `data/raw` pastas foram ignoradas para economizar espaço de versionamento, tanto o dashboard quanto os dados podem ser encontados em links neste documento.

---

## Processo analítico

O trabalho seguiu as etapas do framework do curso.

| Etapa | O que foi feito |
| --- | --- |
| Perguntar | Definição da pergunta de engajamento e retenção e das métricas de adesão por funcionalidade |
| Preparar | Seleção das quatro tabelas relevantes e verificação da cobertura de usuários em cada uma |
| Processar | Limpeza, padronização e validação dos dados com Python e SQL |
| Analisar | Segmentação dos usuários por horas de uso, consistência de sono, consistência de peso e perfil de atividade |
| Compartilhar | Dashboard em Power BI com três páginas, menu lateral e painel de filtros, projetado no Figma |
| Agir | Conclusões e recomendações de produto para a Bellabeat |

### Lógica de análise

1. **Cobertura por funcionalidade.** Contar usuários únicos em cada tabela mede a adesão. A diferença entre tabelas mostra onde o usuário deixa de interagir.
2. **Intensidade de uso do aparelho.** As horas diárias com o dispositivo no corpo separam uso passivo, que não exige ação, de uso ativo.
3. **Consistência de registro.** Para sono e peso, os usuários foram classificados pela frequência com que registram, e não só por terem ou não registro.
4. **Perfil de rotina.** O volume e a intensidade de atividade agrupam os usuários em quatro perfis, e a curva de passos por hora mostra os horários de maior movimento.
5. **Cruzamento entre peso e atividade.** A relação entre passos médios e IMC de quem registra o peso indica quem usa a funcionalidade e por quê.

---

## Principais resultados

### Uso e retenção

<p align="center">
  <a href="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095836.png">
    <img src="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095836.png" alt="Dashboard Bellabeat, página Perfil de Uso: funil de adesão, horas com o aparelho no corpo e consistência de sono e peso" width="100%">
  </a>
</p>
<p align="center"><sub>Página Perfil de Uso: funil de adesão, horas com o aparelho no corpo e consistência de sono e de peso.</sub></p>

**Funil de adesão (usuários únicos por tabela):**

| Funcionalidade | Usuários | % da base |
| --- | ---: | ---: |
| Atividade Diária | 34 | 97,14% |
| Passos por Hora | 34 | 97,14% |
| Sono Diário | 24 | 68,57% |
| Registro de Peso | 12 | 34,29% |

**Horas com o aparelho no corpo:**

| Faixa | Usuários | % |
| --- | ---: | ---: |
| Uso Contínuo (~24h) | 9 | 25,71% |
| Uso Diário Alto (16h a 23h) | 21 | 60,00% |
| Uso Parcial (8h a 15h) | 4 | 11,43% |
| Uso Pontual (menos de 8h) | 1 | 2,86% |

**Consistência de registro:**

| Sono | Usuários | | Peso | Usuários |
| --- | ---: | --- | --- | ---: |
| Sono Insuficiente | 13 | | Nunca registra (0 dias) | 23 |
| Não Registra Sono | 11 | | Esporadicamente (1 a 14 dias) | 10 |
| Sono Ideal | 10 | | Com frequência (15+ dias) | 2 |
| Sono Acima do Normal | 1 | | | |

> **Achado-chave:** 85,71% dos usuários (30 de 35) usam o aparelho 16 horas por dia ou mais, mas só 34,29% registram o peso e apenas 2 o fazem com frequência. O uso passivo é retido; o que depende de uma ação do usuário é abandonado.

### Perfil físico

<p align="center">
  <a href="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095903.png">
    <img src="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095903.png" alt="Dashboard Bellabeat, página Perfil Físico: médias de atividade, picos de movimento por hora, perfis e IMC" width="100%">
  </a>
</p>
<p align="center"><sub>Página Perfil Físico: médias de atividade, picos de movimento por hora, distribuição de perfis e relação entre passos e IMC.</sub></p>

| Indicador | Valor |
| --- | ---: |
| Média de passos por dia | 8,11 mil |
| Média de calorias por dia | 2,34 mil |
| Média de distância por dia | 5,81 km |

- O movimento começa a subir por volta das 5h, se mantém alto durante o dia, com picos no meio do dia e no fim da tarde e uma queda por volta das 15h, e cai de forma acentuada depois das 20h.
- Perfis de volume e intensidade (valores aproximados): **Rotineiro** com cerca de 17 usuários, **Atleta** e **Sedentário** com cerca de 8 cada e **Ativo** com cerca de 2. O perfil Rotineiro é o maior da base.
- Entre quem registra o peso, a maior parte dos pontos fica na linha de IMC 25 ou acima dela, sem relação clara com o volume de passos.

> **Achado-chave:** a concentração de dados acima da linha de IMC 25 mostra que o registro manual de peso gera muito atrito. Apenas usuárias com um problema específico, como sobrepeso, se dão ao trabalho de registrar. A usuária rotineira e saudável abandona a funcionalidade.

### Sono

<p align="center">
  <a href="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095918.png">
    <img src="dashbord/Dashboard Esqueleto/Imagens/Captura de tela 2026-11-16 095918.png" alt="Dashboard Bellabeat, página Perfil de Sono: sono médio, tempo em vigília, qualidade, eficiência e ciclo semanal" width="100%">
  </a>
</p>
<p align="center"><sub>Página Perfil de Sono: sono médio, tempo em vigília, distribuição da qualidade, eficiência e ciclo semanal.</sub></p>

| Indicador | Valor |
| --- | ---: |
| Sono médio | 6h 59m |
| Tempo médio em vigília na cama | 39 min |

| Qualidade do sono | Usuários | % |
| --- | ---: | ---: |
| Sono Insuficiente | 13 | 37,14% |
| Não Registra Sono | 11 | 31,43% |
| Sono Ideal | 10 | 28,57% |
| Sono Acima do Normal | 1 | 2,86% |

- O sono médio de 6h 59m fica abaixo da faixa de 7 a 9 horas geralmente recomendada para adultos.
- No ciclo semanal, o domingo tem o maior valor (cerca de 450 minutos) e os demais dias ficam entre cerca de 400 e 435 minutos.
- No gráfico de eficiência (tempo dormindo contra tempo acordado na cama), a maioria dos usuários passa pouco tempo acordada, em torno da linha de referência de cerca de 30 minutos, com poucos casos bem acima dela.

> **Achado-chave:** 68,57% dos usuários (24 de 35) ou dormem menos que o ideal ou não registram o sono. O sono é uma necessidade evidente e, ao mesmo tempo, uma lacuna de adesão.

---

## Dashboard

O dashboard está publicado no [Power BI Web](https://app.powerbi.com/view?r=eyJrIjoiMGQ0YWU4MWMtYmQyMi00MzNlLTg2YzYtZTVlYmYxOTYwMzJlIiwidCI6IjU1ZWRkMDA3LTY2ZTItNDllOS1iZWM3LWU1YWIxYzFiYWMyNiJ9). Tem três páginas analíticas, acessadas por um menu lateral, e um painel de filtros aberto pelo ícone de funil. O Figma foi usado para projetar a capa, a navegação e a identidade visual.

| Página | Foco | Visuais principais |
| --- | --- | --- |
| Perfil de Uso | Engajamento e retenção | Total de usuários, dias analisados, funil de adesão, horas com o aparelho no corpo, consistência de sono e de peso |
| Perfil Físico | Padrões de rotina diária | Médias de passos, calorias e distância, picos de movimento por hora, perfis de volume e intensidade, passos contra IMC |
| Perfil de Sono | Monitorização noturna | Sono médio, tempo em vigília, distribuição da qualidade, eficiência do sono, ciclo semanal |

### Navegação

<p align="center">
  <a href="dashbord/Gifs/Gravando 2026-11-16 101030.gif">
    <img src="dashbord/Gifs/Gravando 2026-11-16 101030.gif" alt="Navegação entre as páginas do dashboard Bellabeat" width="85%">
  </a>
</p>
<p align="center"><sub>Navegação entre as páginas analíticas pelo menu lateral.</sub></p>

### Filtros

O painel de filtros permite recortar a análise por usuário, por intervalo de datas e por padrão de uso diário. Todos os visuais são recalculados conforme a seleção, e um botão limpa todas as segmentações.

<p align="center">
  <a href="dashbord/Gifs/Gravando 2026-11-16 101711.gif">
    <img src="dashbord/Gifs/Gravando 2026-11-16 101711.gif" alt="Painel de filtros do dashboard Bellabeat com seleção por usuário, data e padrão de uso" width="85%">
  </a>
</p>
<p align="center"><sub>Painel de filtros por usuário, data e padrão de uso diário.</sub></p>

---

## Conclusões gerais

1. **A fricção de uso está no registro manual, não no uso do dispositivo.** Quase toda a base mantém o aparelho no corpo por muitas horas, mas só um terço registra o peso. O atrito aparece onde o produto depende de uma ação deliberada do usuário.
2. **O registro de peso seleciona quem tem um problema específico.** A concentração de dados acima da linha de IMC 25 indica que, em geral, só usuárias com sobrepeso registram. A usuária rotineira e saudável abandona a funcionalidade. Isso também enviesa qualquer leitura feita apenas com esses dados.
3. **O sono é a maior oportunidade de retenção ainda não aproveitada.** Mais de dois terços dos usuários dormem pouco ou não registram o sono, e a média de 6h 59m fica abaixo do recomendado.
4. **A rotina predominante é leve e concentrada em horários previsíveis.** O perfil Rotineiro domina a base, e o ritmo de movimento ao longo do dia permite ações de engajamento no momento certo.
5. **Os resultados descrevem comportamento, não causa.** Os dados mostram quanto e quando os usuários usam cada funcionalidade, mas não os motivos do abandono.

Síntese:

| Dimensão | O que os dados mostram | Implicação para o produto |
| --- | --- | --- |
| Uso do aparelho | 85,71% usam 16h por dia ou mais | O uso passivo é a base de retenção |
| Registro de peso | 34,29% registram, 5,71% com frequência | O registro manual precisa de menos atrito |
| Sono | 68,57% dormem pouco ou não registram | Maior lacuna e maior potencial de valor percebido |
| Rotina | Perfil Rotineiro predominante, picos previsíveis | Metas graduais e comunicação nos horários de pico |

---

## Recomendações para a Bellabeat

| Achado | Recomendação |
| --- | --- |
| O registro manual de peso gera abandono | Reduzir o atrito com integração a balanças inteligentes e lembretes contextuais, e posicionar o peso dentro de um objetivo, não como tarefa isolada |
| O sono tem baixa adesão e fica abaixo do ideal | Usar o sono como porta de entrada para retenção, com resumo matinal simples, metas graduais de rotina noturna e alertas sobre noites curtas |
| O uso passivo é alto | Entregar valor sem pedir ação, com insights automáticos e personalizados a partir dos dados coletados |
| Os picos de movimento são previsíveis | Programar notificações e desafios nos horários de maior atividade e nos vales, como o do meio da tarde |
| O perfil Rotineiro predomina | Criar caminhos de evolução graduais, do movimento leve ao moderado, em vez de metas voltadas a atletas |

---

## Limitações

- **Amostra pequena:** 35 usuários, o que impede generalizar os resultados.
- **Dados de outra marca e de 2016:** o dataset não é da Bellabeat e pode não refletir o comportamento atual do público da empresa.
- **Sem informações demográficas:** não há gênero, idade nem objetivo declarado dos usuários.
- **Viés de seleção no peso:** só 12 usuários registram o peso, e esse grupo não representa a base.
- **Critérios de segmentação definidos na análise:** as faixas de uso, sono, peso e perfil de atividade são decisões do projeto e mudam a distribuição dos grupos se alteradas.
- **Análise descritiva:** não foram aplicados testes estatísticos, e as relações observadas não indicam causa.

---

## Como explorar o projeto

1. Acesse o [dashboard interativo](https://app.powerbi.com/view?r=eyJrIjoiMGQ0YWU4MWMtYmQyMi00MzNlLTg2YzYtZTVlYmYxOTYwMzJlIiwidCI6IjU1ZWRkMDA3LTY2ZTItNDllOS1iZWM3LWU1YWIxYzFiYWMyNiJ9) e use o menu lateral para alternar entre Perfil de Uso, Perfil Físico e Perfil de Sono.
2. Abra o painel de filtros pelo ícone de funil para recortar por usuário, data e padrão de uso diário.
3. Para ver o projeto localmente, clone o repositório:

   ```bash
   git clone https://github.com/AleCecilio/bellabeat_data_analysis.git
   ```

---

## Possíveis melhorias

- Ampliar a análise com um período maior e uma amostra mais diversa de usuários.
- Cruzar sono, atividade e peso por usuário para medir se quem dorme melhor também se movimenta mais.
- Incluir análise de coorte para acompanhar a retenção semana a semana.
- Testar um modelo simples de previsão de abandono de funcionalidade.
- Aplicar testes estatísticos às diferenças entre os grupos.
- Criar uma versão do dashboard otimizada para dispositivos móveis.

---

## Autor

**Alessandro Cecilio**

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/AleCecilio)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/alessandro-cecilio/)

*Projeto desenvolvido para portfólio em Análise e Ciência de Dados.*
