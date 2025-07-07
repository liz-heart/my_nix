{ pkgs, ... }:

let
  # customBottom = import ./bottom.nix { inherit pkgs; };
in {
  home.packages = [ customBottom ];

  xdg.configFile."bottom/bottom.toml".text = ''
    [colors]
    table_header_color = "208"
    avg_cpu_color = "202"
    cpu_core_colors = ["208", "202", "166", "136"]
    ram_color = "208"
    swap_color = "166"
    rx_color = "94"
    tx_color = "130"
    widget_title_color = "250"
    border_color = "235"
    highlighted_border_color = "208"
    text_color = "231"
    graph_color = "208"
    highlighted_text_color = "229"
    cpu_chart_color = "202"

    [flags]
    color = "default"
  '';
}
