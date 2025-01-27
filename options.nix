{
  username = "ray";
  systemConfig = {
    hostname = "EverFrost";
    locale = "en_IN";
    timezone = "Asia/Kolkata";
  };

  userConfig = rec {
    theme = "gruvbox"; # [catppuccin-mocha|gruvbox]
    notificationDaemon = "ags"; # [dunst|ags]
    wm = {
      qtile.enable = false;
      hyprland.enable = true;
    };
    terminal = {
      # Kitty works on both wayland & x11, but foot is wayland only
      kitty.enable = wm.qtile.enable;
      foot.enable = wm.hyprland.enable;
    };
  };
}
