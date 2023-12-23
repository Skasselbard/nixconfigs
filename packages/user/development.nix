{ pkgs, ... }: {

  requiredSystemModules = [ ];

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };
  home.packages = with pkgs; [
    clang
    gradle
    llvm
    maven
    # python3Full
    (python3.withPackages
      (ps: with ps; [ scikit-learn pandas matplotlib numpy ]))
    rustup
  ];
}
