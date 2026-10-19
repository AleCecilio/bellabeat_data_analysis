import pandas as pd

# =====================================================================
# FUNÇÕES AUXILIARES — cada uma retorna uma Série com sufixo no índice
# =====================================================================

def _data_missing_nan(df):
    # Identifica nulos reais (NaN / None) em todas as colunas
    n = df.isna().sum()
    n.index = n.index + ' (Valores NaN / Nulos)'
    return n

def _data_missing_numeric(df):
    # Nota: Atenção com colunas onde 0 é um valor válido (ex: minutos de exercício)
    n = (df.select_dtypes(include='number') == 0).sum()
    n.index = n.index + ' (Zeros - Numérico)'
    return n

def _data_missing_numeric_obj(df):
    n = (df.select_dtypes(include='object') == '0').sum()
    n.index = n.index + ' (Zeros - Texto)'
    return n

def _data_missing_list(df):
    n = (df == '[]').sum()
    n.index = n.index + ' (Listas Vazias)'
    return n

def _data_missing_datetime(df):
    dt_cols = df.select_dtypes(include=['datetime', 'datetime64']).columns
    if len(dt_cols) == 0:
        return pd.Series(dtype='int64')
    n = df[dt_cols].isna().sum()
    n.index = n.index + ' (Valores NaT)'
    return n

# =====================================================================
# MAPA: tipo (string) → função correspondente
# =====================================================================
_TIPOS_MISSING = {
    'nan':         _data_missing_nan,
    'numeric':     _data_missing_numeric,
    'numeric_obj': _data_missing_numeric_obj,
    'list':        _data_missing_list,
    'datetime':    _data_missing_datetime,
}

_TIPOS_DEFAULT = ['nan', 'numeric', 'numeric_obj', 'list', 'datetime']


# =====================================================================
# FUNÇÃO PRINCIPAL — DATA QUALITY
# =====================================================================

def resumo_qualidade(df, tipos=None):
    """
    Gera um DataFrame de diagnóstico de qualidade com contagem e percentual
    de dados faltantes ou anômalos.
    """
    if tipos is None:
        tipos = _TIPOS_DEFAULT

    tipos_invalidos = [t for t in tipos if t not in _TIPOS_MISSING]
    if tipos_invalidos:
        raise ValueError(f"Tipos inválidos: {tipos_invalidos}. Use: {list(_TIPOS_MISSING.keys())}")

    series_list = [_TIPOS_MISSING[t](df) for t in tipos]
    series_list = [s for s in series_list if not s.empty]

    # Retorna DataFrame vazio se não houver nenhuma anomalia encontrada
    if not series_list:
        return pd.DataFrame(columns=['Quantidade', 'Perda de Dados (%)'])

    resumo_bruto = pd.concat(series_list)
    resumo_filtrado = resumo_bruto[resumo_bruto > 0]

    if resumo_filtrado.empty:
        return pd.DataFrame(columns=['Quantidade', 'Perda de Dados (%)'])

    return (
        pd.DataFrame({
            'Quantidade':         resumo_filtrado,
            'Perda de Dados (%)': (resumo_filtrado / len(df)) * 100
        })
        .sort_values('Perda de Dados (%)', ascending=False)
    )