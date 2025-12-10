{pkgs, ...}: {
  home.pkgs = with pkgs; [
    typst
    tinymist
  ];

  programs.helix = {
    languages.language = [
      {
        name = "typst";
        language-servers = ["tinymist"];
        auto-format = true;
      }
    ];
  };
}
