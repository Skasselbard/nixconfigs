{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    clang
    gradle
    jdk17
    llvm
    maven
    # python3Full
    (python3.withPackages
      (ps: with ps; [ scikit-learn pandas matplotlib numpy ]))
    rustup
  ];
}
