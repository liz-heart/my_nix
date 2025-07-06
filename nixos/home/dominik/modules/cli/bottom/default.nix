{ pkgs, ... }:

{
  home.packages = with pkgs; [ bottom ];

  xdg.configFile."bottom/bottom.toml".text = ''
    [colors]
    table_header_color = "208"          # Papaya Orange (ANSI 208)
    avg_cpu_color = "202"               # Knalliges Orange-Rot
    cpu_core_colors = ["196", "226", "46", "21", "51"] # Rot, Gelb, Grün, Blau, Cyan (Chrome-Reifenfarben)
    ram_color = "130"                   # Terrakotta
    swap_color = "129"                  # Magenta-beige Mischung
    rx_color = "34"                     # Sattes Grün (für Natur)
    tx_color = "39"                     # Himmelblau
    widget_title_color = "250"          # Hellgrau für Lesbarkeit
    border_color = "235"                # Dunkelgrau/Asphaltfarbe
    highlighted_border_color = "208"    # Papaya Orange
    text_color = "231"                  # Weiß für Kontrast
    graph_color = "39"                  # Monaco-Himmelblau
    highlighted_text_color = "46"       # Leuchtgrün
    cpu_chart_color = "51"              # Chrome-Cyan

    [flags]
    color = "default"
  '';
}
