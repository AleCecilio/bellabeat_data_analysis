import os
from pathlib import Path
import pandas as pd

# Funções auxiliares para carregamento e inspeção de dados

def _list_available_tables(raw_data_path: str) -> list:
    """Varre a pasta de dados brutos (raw) e retorna uma lista ordenada com

    os nomes únicos de todas as tabelas CSV disponíveis.
    """
    raw_path = Path(raw_data_path)
    files = list(raw_path.rglob("*.csv"))
    table_names = {file.stem for file in files}
    return sorted(list(table_names))


# Funções públicas

def inspect_samples(raw_data_path: str, n_rows: int = 3) -> dict:
    """Carrega uma pequena amostra (n_rows) de cada tabela encontrada na pasta de

    dados brutos. Retorna um dicionário com o nome da tabela como chave e o
    DataFrame de amostra como valor.
    """
    raw_path = Path(raw_data_path)
    tables = _list_available_tables(raw_data_path)

    samples = {}
    for table in tables:
        # Pega a primeira ocorrência do arquivo para servir de modelo
        sample_file = list(raw_path.rglob(f"{table}.csv"))[0]
        samples[table] = pd.read_csv(sample_file, nrows=n_rows)

    return samples


def load_and_concatenate_csvs(
    raw_data_path: str, table_name: str
) -> pd.DataFrame:
    """Localiza e concatena os arquivos CSV correspondentes ao longo das subpastas

    de cada mês.
    """
    raw_path = Path(raw_data_path)
    found_files = list(raw_path.rglob(f"{table_name}.csv"))

    if not found_files:
        raise FileNotFoundError(
            f"Nenhum arquivo encontrado para: {table_name}.csv em {raw_data_path}"
        )

    dfs = []
    for file in found_files:
        df = pd.read_csv(file)
        # Registra qual subpasta originou os registros para rastreabilidade
        df['source_folder'] = file.parent.name
        dfs.append(df)

    df_concatenated = pd.concat(dfs, ignore_index=True)
    return df_concatenated