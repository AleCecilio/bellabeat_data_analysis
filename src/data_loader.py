import os
from pathlib import Path
import pandas as pd

# =====================================================================
# FUNÇÕES PARA CARREGAMENTO E INSPEÇÃO DE DADOS
# =====================================================================

def _list_available_tables(caminho_dados_brutos: str) -> list:
    """
    Varre a pasta de dados brutos (raw) e retorna uma lista ordenada com
    os nomes únicos de todas as tabelas CSV disponíveis.
    """

    caminho_bruto = Path(caminho_dados_brutos)
    arquivos = list(caminho_bruto.rglob("*.csv"))
    nomes_tabelas = {arquivo.stem for arquivo in arquivos}
    return sorted(list(nomes_tabelas))


# =====================================================================
#   FUNÇÕES PÚBLICAS DE CARREGAMENTO DE DADOS
# =====================================================================

def load_table(caminho_dados: str, nome_tabela: str) -> pd.DataFrame:
    """
    Carrega uma tabela específica a partir da pasta de dados brutos (raw).
    Retorna um DataFrame contendo os dados da tabela.
    """
    caminho_bruto = Path(caminho_dados)
    arquivo_tabela = list(caminho_bruto.rglob(f"{nome_tabela}.csv"))

    if not arquivo_tabela:
        raise FileNotFoundError(
            f"Nenhum arquivo encontrado para: {nome_tabela}.csv em {caminho_dados}"
        )

    df_tabela = pd.read_csv(arquivo_tabela[0])
    return df_tabela

def inspect_samples(caminho_dados_brutos: str, qtd_linhas: int = 3) -> dict:
    """
    Carrega uma pequena amostra (qtd_linhas) de cada tabela encontrada na pasta de
    dados brutos. Retorna um dicionário com o nome da tabela como chave e o
    DataFrame de amostra como valor.
    """
    caminho_bruto = Path(caminho_dados_brutos)
    tabelas = _list_available_tables(caminho_dados_brutos)

    amostras = {}
    for tabela in tabelas:
        # Pega a primeira ocorrência do arquivo para servir de modelo
        arquivo_amostra = list(caminho_bruto.rglob(f"{tabela}.csv"))[0]
        amostras[tabela] = pd.read_csv(arquivo_amostra, nrows=qtd_linhas)

    return amostras


def load_and_concatenate_csvs(
    caminho_dados_brutos: str, nome_tabela: str
) -> pd.DataFrame:
    """
    Localiza e concatena os arquivos CSV correspondentes ao longo das subpastas
    de cada mês.
    """
    caminho_bruto = Path(caminho_dados_brutos)
    arquivos_encontrados = list(caminho_bruto.rglob(f"{nome_tabela}.csv"))

    if not arquivos_encontrados:
        raise FileNotFoundError(
            f"Nenhum arquivo encontrado para: {nome_tabela}.csv em {caminho_dados_brutos}"
        )

    lista_dfs = []
    for arquivo in arquivos_encontrados:
        df_item = pd.read_csv(arquivo)

        # Registra qual subpasta originou os registros para rastreabilidade
        df_item['source_folder'] = arquivo.parent.name

        lista_dfs.append(df_item)

    df_concatenado = pd.concat(lista_dfs, ignore_index=True)
    return df_concatenado