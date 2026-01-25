{pkgs, ...}: {
  home.packages = with pkgs; [
    texstudio
    wtype
    (pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-medium
        xcolor
        framed
        fancyvrb
        etoolbox
        psnfss # provides Times fonts (ptmr7t, ptmb7t, etc.)
        cite # provides cite.sty
        platex-tools # some IEEEtran dependencies
        latex-bin
        collection-fontsrecommended
        algorithms
        latexmk
        latexindent
        beamer
        lipsum
        tcolorbox
        biblatex
        biber
        ; # essential font metrics
    })
    (
      pkgs.writers.writeNuBin "zotpicknixnu" ''
        let textEditor = "texstudio"
        let CAYW_URL = "http://localhost:23119/better-bibtex/cayw?format=cite&clipboard=true"


        # Probe Better BibTeX status
        let BBT_status = (http get ([$CAYW_URL "&probe=probe"] | str join))

        # Match on BBT_status to handle logic
        match $BBT_status {
            "ready" => {
                http get $CAYW_URL
                exit 0
            }
            "" => {
                notify-send "Please launch Zotero with the Better BibTeX plugin. If Zotero is running, check 'Enable export by HTTP' in BBT and restart Zotero."
                exit 4
            }
            "No endpoint found" => {
                notify-send "Better BibTeX cannot find your library. Ensure only one Zotero instance is open. If so, reinstall Better BibTeX."
                exit 5
            }
            _ => {
                notify-send "Unknown error in Better BibTex. Please restart Zotero and try again."
                exit 5
            }
        }
      ''
    )
  ];
}
