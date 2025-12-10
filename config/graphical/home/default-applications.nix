{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "okularApplication_pdf.desktop";

      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
    };
  };
}
