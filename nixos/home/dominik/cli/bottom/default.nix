{ pkgs, ... }:

{
  home.packages = with pkgs; [ bottom ];

  xdg.configFile."bottom/bottom.toml".text = ''
    [colors]
    table_header_color = "Orange"
    avg_cpu_color = "Red"
    cpu_core_colors = ["Red", "Yellow", "Green", "Blue"]
    ram_color = "Yellow"
    swap_color = "Magenta"
    rx_color = "Green"
    tx_color = "Cyan"
    widget_title_color = "Gray"
    border_color = "Black"
    highlighted_border_color = "Orange"
    text_color = "White"
    graph_color = "LightBlue"
    highlighted_text_color = "LightGreen"
    cpu_chart_color = "Cyan"

    [flags]
    color = "default"
  '';
}
