{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    nixd
    nil
    clang-tools
    marksman
    lua-language-server
    jdt-language-server
  ];
}
