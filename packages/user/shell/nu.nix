{ pkgs, lib, ... }: {
  requiredSystemModules = [ ];
  # home.packages = let
  #   # nu-plugin = let version = "v0.88.1";
  #   # in pkgs.rustPlatform.buildRustPackage {
  #   #   pname = "nu-plugin";
  #   #   inherit version;
  #   #   cargoHash = lib.fakeHash;
  #   #   # cargoHash = "sha256-mOmVOPBWENCloA9HcORVSm/dAv6OT/EsIJZ2xVA6MhI=";

  #   #   src = pkgs.fetchFromGitHub {
  #   #     owner = "nushell";
  #   #     repo = "nushell";
  #   #     rev = "refs/tags/${version}";
  #   #     hash = "";
  #   #   } + /crates/nu-plugin;
  #   #   meta = with lib; {
  #   #     description = "Script for syntax highlight in nushell output:";
  #   #     homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
  #   #   };
  #   # };
  #   nu-highlight = let version = "v1.0.7";
  #   in pkgs.rustPlatform.buildRustPackage {
  #     pname = "nu_plugin_highlight";
  #     inherit version;
  #     cargoHash = lib.fakeHash;

  #     src = pkgs.fetchFromGitHub {
  #       owner = "cptpiepmatz";
  #       repo = "nu-plugin-highlight";
  #       rev = "refs/tags/${version}";
  #       hash = "sha256-mOmVOPBWENCloA9HcORVSm/dAv6OT/EsIJZ2xVA6MhI=";
  #     };
  #     # buildInputs = with pkgs; [ nu-plugin ];
  #     meta = with lib; {
  #       description = "Script for syntax highlight in nushell output:";
  #       homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
  #     };
  #   };
  # in [ nu-highlight ];
  programs = {
    nushell =
      # let
      #   nu_scripts = builtins.fetchGit {
      #     url = "https://github.com/nushell/nu_scripts.git";
      #     ref = "main";
      #   };
      #   dns = builtins.fetchGit {
      #     url = "https://github.com/dead10ck/nu_plugin_dns.git";
      #     ref = "refs/tags/v1.0.3";
      #   };
      #   highlight = builtins.fetchGit {
      #     url = "https://github.com/nushell/nu_scripts.git";
      #     ref = "refs/tags/v1.0.7";
      #   };
      #   net = builtins.fetchGit {
      #     url = "https://github.com/fdncred/nu_plugin_pnet.git";
      #     ref = "main";
      #   };
      # in 
      {
        enable = true;
        package = pkgs.nushell;
        # configFile.text = '' '';
        # extraConfig =
        #   "starship preset nerd-font-symbols -o ~/.config/starship.toml";
        # loginFile = null;
        shellAliases = { ll = "ls -l"; };
        extraConfig = ''
          def sshamnesia --wrapped [...args] {
            ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' -o 'LogLevel=ERROR' ($args | str join " ")
                }
        '';
        # envFile.text = ''
        #   source ${nu_scripts}/modules/data_extraction/ultimate_extractor.nu
        # '';
      };
  };
}
