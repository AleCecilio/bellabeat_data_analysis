import pandas as pd

# =====================================================================
# FUNÇÕES AUXILIARES — cada uma retorna uma Série com sufixo no índice
# =====================================================================

def _data_missing_nan(df):
    """Conta a quantidade de valores nulos (NaN) reais no DataFrame."""
    
    n = df.isna().sum()
    n.index = n.index + ' (Nulos/NaN)'
    return n

def _data_missing_numeric(df):
    """Identifica e conta valores iguais a zero numéricos (int/float)."""

    n = (df.select_dtypes(include='number') == 0).sum()
    n.index = n.index + ' (Valores Zero)'
    return n

def _data_missing_numeric_obj(df):
    """Identifica e conta valores iguais a '0' armazenados como texto."""

    n = (df.select_dtypes(include='object') == '0').sum()
    n.index = n.index + ' (Zeros em Texto)'
    return n

def _data_missing_list(df):
    """Verifica a presença de listas vazias representadas como string '[]'."""

    n = (df == '[]').sum()
    n.index = n.index + ' (Listas Vazias)'
    return n

def _data_missing_datetime(df):
    """Verifica valores nulos (NaT) especificamente em colunas de data e hora."""

    dt_cols = df.select_dtypes(include=['datetime', 'datetime64']).columns

    if len(dt_cols) == 0:
        return pd.Series(dtype='int64')
    
    n = df[dt_cols].isna().sum()
    n.index = n.index + ' (Datas Inválidas/NaT)'
    return n

def _data_missing_empty_strings(df):
    """Procura por strings vazias ou compostas apenas por espaços em branco."""

    str_cols = df.select_dtypes(include=['object', 'string']).columns
    if len(str_cols) == 0:
        return pd.Series(dtype='int64')
    
    # O .str.strip() remove os espaços. Se sobrar '', é porque estava vazia ou só tinha espaço
    n = df[str_cols].apply(lambda x: (x.str.strip() == '')).sum()
    n.index = n.index + ' (Strings Vazias/Espaços)'
    return n

def _data_negative_numeric(df):
    """Busca erros de software (ex: -500 passos, -10 calorias)."""

    n = (df.select_dtypes(include='number') < 0).sum()
    n.index = n.index + ' (Valores Negativos)'
    return n

def _data_duplicates(df):
    """Busca falhas de sincronização (linhas 100% idênticas)."""

    dup_count = df.duplicated().sum()
    if dup_count > 0:
        return pd.Series([dup_count], index=['Linhas Duplicadas (Tabela Inteira)'])
    
    return pd.Series(dtype='int64')

def _data_inconsistent_minutes(df):
    """Valida a regra de negócio de 24h (1440 min) apenas se as colunas existirem."""

    cols_minutos = [
        'very_active_minutes', 'fairly_active_minutes', 
        'lightly_active_minutes', 'sedentary_minutes'
    ]

    # Executa apenas se todas as colunas de minutos estiverem na tabela (ex: daily_activity)

    if all(c in df.columns for c in cols_minutos):
        total_mins = df[cols_minutos].sum(axis=1)
        inconsistent_count = (total_mins > 1440).sum()

        if inconsistent_count > 0:
            return pd.Series([inconsistent_count], index=['Minutos > 1440 (Anomalia Diária)'])
        
    return pd.Series(dtype='int64')

# =====================================================================
# MAPA: tipo (string) → função correspondente
# =====================================================================
_TIPOS_MISSING = {
    'nan':               _data_missing_nan,
    'numeric':           _data_missing_numeric,
    'numeric_obj':       _data_missing_numeric_obj,
    'list':              _data_missing_list,
    'datetime':          _data_missing_datetime,
    'empty_str':         _data_missing_empty_strings,
    'negatives':         _data_negative_numeric,       
    'duplicates':        _data_duplicates,             
    'inconsistent_mins': _data_inconsistent_minutes,   
}
_TIPOS_DEFAULT = [
    'nan', 'numeric', 'numeric_obj', 'list', 'datetime', 
    'empty_str', 'negatives', 'duplicates', 'inconsistent_mins'
]

# =====================================================================
# FUNÇÃO PRINCIPAL — DATA QUALITY
# =====================================================================

def check_data_quality(df, tipos=None, ignorar_zeros_em=None):
    """
    Gera um DataFrame de diagnóstico de qualidade destacando valores nulos,
    incidência de zeros, duplicatas e anomalias de regra de negócio (FitBit).
    """
    if tipos is None:
        tipos = _TIPOS_DEFAULT
    if ignorar_zeros_em is None:
        ignorar_zeros_em = []

    tipos_invalidos = [t for t in tipos if t not in _TIPOS_MISSING]
    if tipos_invalidos:
        raise ValueError(f"Tipos inválidos: {tipos_invalidos}. Use: {list(_TIPOS_MISSING.keys())}")

    series_list = []
    
    for t in tipos:
        s = _TIPOS_MISSING[t](df)
        
        if t == 'numeric' and ignorar_zeros_em and not s.empty:
            indices_para_remover = [col + ' (Valores Zero)' for col in ignorar_zeros_em]
            s = s[~s.index.isin(indices_para_remover)]
            
        series_list.append(s)

    series_list = [s for s in series_list if not s.empty]

    if not series_list:
        return pd.DataFrame(columns=['Quantidade', 'Incidência (%)'])

    resumo_bruto = pd.concat(series_list)
    resumo_filtrado = resumo_bruto[resumo_bruto > 0]

    if resumo_filtrado.empty:
        return pd.DataFrame(columns=['Quantidade', 'Incidência (%)'])

    return (
        pd.DataFrame({
            'Quantidade':     resumo_filtrado,
            'Incidência (%)': (resumo_filtrado / len(df)) * 100
        })
        .sort_values('Incidência (%)', ascending=False)
        .round(2)
    )