import seaborn as sns
import matplotlib.pyplot as plt


# ===== Barplot Horizontal de Auditoria de Dados Faltantes =====

def chart_percentage_missing_data(df_plot, tamanho_figura=None, polegadas=150, width=0.6, nome_dataframe=None):
    """
    Gera um barplot horizontal focado em auditoria visual (QA).
    O tamanho vertical do gráfico se ajusta automaticamente à quantidade de dados.
    """

    # Trava de Segurança: Aborta o gráfico se não houver dados para plotar
    if df_plot.empty:
        return

    qtd_barras = len(df_plot)

    # Otimização Automática de Tamanho 
    if tamanho_figura is None:
        if qtd_barras == 1:
            altura_dinamica = 1.8  # Altura bem menor para não esticar
        elif qtd_barras <= 3:
            altura_dinamica = 2.8
        else:
            altura_dinamica = (qtd_barras * 0.5) + 2.0
            
        tamanho_figura = (10, altura_dinamica)

    plt.figure(figsize=tamanho_figura, dpi=polegadas)

    plt.gca().set_axisbelow(True)
    plt.grid(axis='x', linestyle='--', alpha=0.4, color='#9A8C98')

    ax = sns.barplot(
        x='Incidência (%)',
        y=df_plot.index,
        data=df_plot,
        hue=df_plot.index,
        palette='Reds_r',
        legend=False,
        width=width
    )

    for container in ax.containers:
        ax.bar_label(
            container,
            padding=5,
            fontsize=10,
            fontweight='semibold',
            color='#2B2D42',
            fmt='%.2f%%'
        )

    # Tratamento dinâmico de Título
    titulo = f'Auditoria de Perda de Dados por Coluna - {nome_dataframe}' if nome_dataframe else 'Auditoria de Perda de Dados por Coluna'
    
    plt.title(
        titulo, 
        fontsize=15, 
        fontweight='bold', 
        color='#2B2D42', 
        pad=20
    )

    plt.xlabel('Incidência (%)', fontsize=11, fontweight='semibold', color='#4A4E69')
    plt.ylabel('Atributo', fontsize=11, fontweight='semibold', color='#4A4E69')
    
    # Limite do eixo X (com folga de 15% para o label da barra não cortar)
    plt.xlim(0, df_plot['Incidência (%)'].max() * 1.15)

    sns.despine(left=True, bottom=True)
    plt.tight_layout()
    plt.show()