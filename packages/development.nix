{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    clang
    gradle
    jdk17
    llvm
    maven
    python3Full
    rustup
  ];
}
