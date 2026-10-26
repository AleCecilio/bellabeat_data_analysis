# Garante que a pasta de destino exista
import os


def save_dataframes_to_csv(dfs: dict, destino: str, sufixo: str = "") -> None:
    """
    Salva os DataFrames em arquivos CSV na pasta de destino.
    """ 
    os.makedirs(destino, exist_ok=True)

    # Exporta cada dataframe concatenado
    for nome_tabela, df in dfs.items():
        # O arquivo será salvo na camada intermediária
        save_path = f"{destino}/{nome_tabela}{sufixo}.csv"
        
        # index=False evita criar uma coluna inútil com o número da linha
        df.to_csv(save_path, index=False)
        print(f"Ingestão finalizada: {save_path} ({df.shape[0]} linhas geradas)")

    print("\nIngestão completa!")