{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    nixd
    nil
    clang-tools
    marksman
    lua-language-server
    jdt-language-server
    jsonfmt
    python313Packages.python-lsp-server
    texlab
  ];
}
