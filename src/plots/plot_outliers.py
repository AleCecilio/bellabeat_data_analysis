import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import seaborn as sns

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


# ==============================================================================
#   Gráfico: Radar de Impacto de Outliers (Resumo em Lote)
# ==============================================================================
def radar_chart_outliers(
    df_diagnostico,
    cor_tema='#4A4E69',
    titulo="Impacto de Outliers por Métrica",
    tamanho_figura=(10, 5),
    polegadas=120
):
    """
    Gera um gráfico de barras horizontais ranqueando a incidência de outliers por coluna.
    """
    if df_diagnostico.empty or 'Coluna' not in df_diagnostico.columns:
        print("Nenhum outlier encontrado para exibir no gráfico.")
        return

    df_plot = df_diagnostico.copy()

    # Conversão direta e à prova de falhas (remove o '%' e converte para float)
    df_plot['Impacto_Num'] = (
        df_plot['Impacto (%)']
        .astype(str)
        .str.replace('%', '', regex=False)
        .astype(float)
    )

    # Ordena em ordem crescente para que a barra mais longa fique no topo no gráfico horizontal
    df_plot = df_plot.sort_values(by='Impacto_Num', ascending=True)

    fig, ax = plt.subplots(figsize=tamanho_figura, dpi=polegadas)

    # Desenho das barras
    bars = ax.barh(
        y=df_plot['Coluna'],
        width=df_plot['Impacto_Num'],
        color=cor_tema,
        alpha=0.85,
        height=0.6
    )

    # Adiciona o rótulo de % na ponta de cada barra
    for bar in bars:
        val = bar.get_width()
        ax.text(
            val + (df_plot['Impacto_Num'].max() * 0.015), # Ligeiro recuo à direita da barra
            bar.get_y() + bar.get_height() / 2,           # Centro vertical
            f'{val:.2f}%',
            va='center',
            ha='left',
            fontsize=10,
            fontweight='bold',
            color='#2b2d42'
        )

    # Estética corporativa
    ax.set_title(titulo, fontsize=14, fontweight='bold', pad=15, color='#2b2d42')
    ax.set_xlabel('Incidência na Tabela (%)', fontsize=11, fontweight='bold', color='#4A4E69')
    ax.set_ylabel('')

    # Expande o limite X para garantir espaço aos rótulos de texto
    max_val = df_plot['Impacto_Num'].max()
    ax.set_xlim(0, max_val * 1.2 if max_val > 0 else 10)

    # Grelha vertical sutil
    ax.set_axisbelow(True)
    ax.grid(axis='x', linestyle='--', alpha=0.4, color='#BDBDBD')

    sns.despine(top=True, right=True, left=False, bottom=False)
    plt.tight_layout()
    plt.show()

# ==============================================================================
#   Gráfico de Análise de Outliers 
# ==============================================================================
def outlier_plot(
    df_plot,
    coluna,
    cerca_superior,
    cerca_inferior=None,
    cor_tema='#4A4E69',
    titulo=None,
    tamanho_figura=None,
    polegadas=None,
    width=None,
    usar_log=False
):
    """Gera um gráfico composto (Boxplot + Stripplot) evidenciando as fronteiras de outliers."""
    
    if df_plot.empty or df_plot[coluna].dropna().empty:
        print(f"Sem dados válidos para plotar a coluna: {coluna}.")
        return

    if tamanho_figura is None:
        tamanho_figura = (10, 4)
    if polegadas is None:
        polegadas = 120
    if width is None:
        width = 0.5

    fig, ax = plt.subplots(figsize=tamanho_figura, dpi=polegadas)
    
    ax.set_axisbelow(True)
    ax.grid(axis='x', linestyle='--', alpha=0.4, color='#BDBDBD')

    if usar_log:
        ax.set_xscale('log')
        ax.xaxis.set_minor_locator(ticker.NullLocator())
    else:
        ax.xaxis.set_major_formatter(ticker.StrMethodFormatter('{x:,.0f}'))

    sns.boxplot(
        x=df_plot[coluna], 
        ax=ax, 
        color=cor_tema, 
        width=width, 
        fliersize=0, 
        linewidth=1.5,
        boxprops=dict(alpha=0.3)
    )
    
    sns.stripplot(
        x=df_plot[coluna], 
        ax=ax, 
        color=cor_tema, 
        size=3.5,     
        alpha=0.4,    
        jitter=0.25
    )
    
    #  Desenha a Cerca Superior (Sempre)
    ax.axvline(
        cerca_superior, 
        color='#E63946',
        linestyle='--', 
        linewidth=2.0, 
        label=f'Cerca Sup. ({cerca_superior:,.0f})'
    )
    
    # Desenha a Cerca Inferior APENAS se for fornecida e fizer sentido
    if cerca_inferior is not None:
        ax.axvline(
            cerca_inferior, 
            color='#E63946',
            linestyle=':', 
            linewidth=2.0, 
            label=f'Cerca Inf. ({cerca_inferior:,.0f})'
        )

    nome_coluna_limpo = coluna.replace('_', ' ').title()
    titulo_real = titulo if titulo else f"Distribuição de {nome_coluna_limpo} e Fronteiras de Outliers"
    
    ax.set_title(
        titulo_real, 
        fontsize=14, 
        fontweight='bold', 
        pad=15, 
        color='#2b2d42'
    )
    
    label_x = f"{nome_coluna_limpo} (Escala Logarítmica)" if usar_log else nome_coluna_limpo
    ax.set_xlabel(label_x, fontsize=11, fontweight='bold', color='#4A4E69')

    ax.legend(
        loc='upper right', 
        frameon=True, 
        shadow=False, 
        edgecolor='#E0E0E0', 
        facecolor='white',
        fontsize=10
    )
    
    sns.despine(left=True)
    ax.yaxis.set_visible(False)
    
    plt.tight_layout()
    plt.show()