{pkgs, ...}: let
  # 🔌 Run any applicaton from terminal in detached mode
  orphan = pkgs.writeShellApplication {
    name = "orphan";
    text = ''
      nohup "$@" > /dev/null 2>&1 &
      disown
    '';
  };

  backup-file = pkgs.writeShellApplication {
    name = "bak";
    text = ''
      cp "$1" "$1.bak"
    '';
  };

  # 🛫 To remove nixos system generations with ease
  rm-sys-gens = pkgs.writeShellApplication {
    name = "rm-sys-gens";
    text = ''
      profile_path="/nix/var/nix/profiles/system"
      sudo nix-env --list-generations --profile "$profile_path"
      keep=$(gum input --placeholder "Recent gens to keep? ")
      sudo nix-env --delete-generations +"$keep" --profile "$profile_path"
    '';
  };

  # Same as rm-sys-gens but for home-manager
  hm-remove-gens = pkgs.writeShellApplication {
    name = "hm-remove-gens";
    text = ''
      gens=$(home-manager generations | awk '{print $5}')
      first_id=$(echo "$gens" | awk '{print $NF}')
      last_id=$(echo "$gens" | awk '{print $1}')
      total_gens=$(echo "$gens" | wc -w)

      echo "Total $total_gens generations found" \
          "$first_id - $last_id"

      keep=$(gum input --placeholder "How many recent generations to keep?")
      remove=$(echo "$gens" | tail -n +"''$((keep + 1))")

      if [[ -z "$keep" ]]; then
          echo "None selected, exiting..."
          exit 1
      fi

      gum spin --spinner="dot" --title="Cleaning up generation..." \
          -- home-manager remove-generations "$remove"
      echo "Success!"
    '';
  };
in {
  home.packages = [
    rm-sys-gens
    orphan
    backup-file
    hm-remove-gens
  ];
}
