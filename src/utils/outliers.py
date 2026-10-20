import pandas as pd

# ==============================================================================
# Cálculo de Limites de Outliers (Método IQR)
# ==============================================================================
def calculate_limits_iqr (df, coluna, multiplicador=1.5):
    """
    Calcula os limites estatísticos (Cerca Inferior e Superior).
    """
    if coluna not in df.columns or not pd.api.types.is_numeric_dtype(df[coluna]):
        raise ValueError(f"A coluna '{coluna}' não existe ou não é numérica.")

    Q1 = df[coluna].quantile(0.25)
    Q3 = df[coluna].quantile(0.75)
    IQR = Q3 - Q1
    
    limite_inferior = Q1 - (multiplicador * IQR)
    limite_superior = Q3 + (multiplicador * IQR)
    
    return limite_inferior, limite_superior

# ==============================================================================
# 2. FUNÇÃO EM LOTE: Radar de Outliers
# ==============================================================================
def batch_outlier_diagnosis(df, colunas_ignorar=None):
    """
    Varre todas as colunas numéricas de um DataFrame, utiliza a função base 
    de limites IQR e retorna um relatório ranqueado com as colunas afetadas.
    """
    if colunas_ignorar is None:
        colunas_ignorar = []
        
    cols_numericas = df.select_dtypes(include='number').columns
    cols_analise = [c for c in cols_numericas if c not in colunas_ignorar]
    
    resultados = []
    total_linhas = len(df)
    
    for col in cols_analise:
        # AQUI: Chamamos a função base em vez de reescrever a matemática!
        limite_inf, limite_sup = calculate_limits_iqr(df, col)
        
        outliers_sup = (df[col] > limite_sup).sum()
        outliers_inf = (df[col] < limite_inf).sum()
        total_outliers = outliers_sup + outliers_inf
        
        if total_outliers > 0:
            resultados.append({
                'Coluna': col,
                'Qtd Outliers': total_outliers,
                'Impacto (%)': (total_outliers / total_linhas) * 100,
                'Cerca Inf': limite_inf,
                'Cerca Sup': limite_sup
            })
            
    if not resultados:
        return pd.DataFrame(columns=['Coluna', 'Nenhum Outlier Encontrado'])
        
    df_resumo = pd.DataFrame(resultados).sort_values(by='Impacto (%)', ascending=False)
    df_resumo['Impacto (%)'] = df_resumo['Impacto (%)'].round(2).astype(str) + '%'
    df_resumo['Cerca Inf'] = df_resumo['Cerca Inf'].round(2)
    df_resumo['Cerca Sup'] = df_resumo['Cerca Sup'].round(2)
    
    return df_resumo.reset_index(drop=True)

import pandas as pd
from IPython.display import display

# ==============================================================================
# FUNÇÃO: Resumo e Inspeção Detalhada de Outliers por Coluna
# ==============================================================================
def outliers_summary(
    df, 
    coluna, 
    limite_sup, 
    limite_inf=None, 
    colunas_analise=None, 
    titulo=None
):
    """
    Realiza uma análise detalhada dos outliers de qualquer coluna num DataFrame:
    - Calcula métricas de impacto e volumetria.
    - Agrupa a incidência por utilizador (user_id).
    - Exibe a tabela ordenada com os registros mais extremos.
    """
    # 1. Validação de segurança inicial
    if coluna not in df.columns:
        print(f"A coluna '{coluna}' não existe no DataFrame fornecido.")
        return

    # 2. Filtro dinâmico considerando cerca superior e opcionalmente inferior
    if limite_inf is not None:
        outliers = df[(df[coluna] > limite_sup) | (df[coluna] < limite_inf)]
    else:
        outliers = df[df[coluna] > limite_sup]

    total_registros = len(df)
    qtd_outliers = len(outliers)
    pct_outliers = (qtd_outliers / total_registros) * 100 if total_registros > 0 else 0

    # 3. Impressão do Sumário Executivo
    print(f"============================================================")
    print(f"   RESUMO DE OUTLIERS: {coluna.upper()} ")
    print(f"============================================================")
    print(f"• Cerca Superior (IQR): {limite_sup:,.2f}")
    if limite_inf is not None:
        print(f"• Cerca Inferior (IQR): {limite_inf:,.2f}")
    print(f"• Quantidade de Outliers: {qtd_outliers} de {total_registros} registros")
    print(f"• Impacto na Tabela: {pct_outliers:.2f}%\n")

    if not outliers.empty:
        print(f"• Valor mínimo entre outliers: {outliers[coluna].min():,.2f}")
        print(f"• Valor máximo entre outliers: {outliers[coluna].max():,.2f}\n")
    else:
        print("Nenhum registro ultrapassou os limites calculados.")
        return

    # 4. Agrupamento dinâmico de outliers por utilizador (suporta 'user_id' ou 'Id')
    col_id = 'user_id' if 'user_id' in df.columns else ('Id' if 'Id' in df.columns else None)
    
    if col_id:
        outliers_por_usuario = (
            outliers[col_id]
            .value_counts()
            .reset_index()
            .rename(columns={'count': 'dias_com_outlier', col_id: 'Id_Usuario'})
        )
        print("Distribuição de outliers por Utilizador:")
        display(outliers_por_usuario)
    else:
        print("Coluna de identificação de utilizador não encontrada para agrupamento.")

    # 5. Configuração e Exibição da Tabela Detalhada (Inspeção Tabular)
    if colunas_analise is None:
        # Se nenhuma coluna foi especificada, pega as 6 primeiras do df por padrão
        colunas_analise = list(df.columns[:6])

    # Garante que a coluna analisada e o ID estejam presentes na exibição
    cols_para_exibir = list(dict.fromkeys([c for c in [col_id, coluna] + colunas_analise if c in df.columns]))

    titulo_real = titulo if titulo else f"Top 10 registros mais extremos para: {coluna}"
    print(f"\n{titulo_real}:")
    
    display(
        outliers[cols_para_exibir]
        .sort_values(by=coluna, ascending=False)
        .head(10)
    )