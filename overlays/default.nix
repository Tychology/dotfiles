[
  #  (self: super: {
  #    krb5 = super.krb5.overrideAttrs (oldAttrs: {
  #      src = ./krb5-1.21.3.tar.gz;
  #    });
  #  })
  #  (self: super: {
  #    libidn2 = super.libidn2.overrideAttrs (oldAttrs: {
  #      src = ./libidn2-2.3.8.tar.gz;
  #    });
  #  })
  # (self: super: {
  #   ddcutil = super.ddcutil.overrideAttrs (oldAttrs: {
  #     src = super.fetchurl {
  #       url = oldAttrs.src.url;
  #       sha256 = "6K3wL/d1IW561uoXIN0kuAm0JNzQJXsqN8IPLRu3M7k=";
  #     };
  #   });
  # })
  (self: super: {
    checkbashisms = super.checkbashisms.overrideAttrs (oldAttrs: {
      version = "2.25.15";
      src = super.fetchurl {
        url = "mirror://debian/pool/main/d/devscripts/devscripts_2.25.15.tar.xz";
        hash = "sha256-TADjFjihtSePKG1NyTvEIAA9pT+JHV3Rmd4VxInM0Kw==";
      };
    });
  })
  # (self: super: {
  #   libcap_ng = super.libcap_ng.overrideAttrs (oldAttrs: {
  #     version = "0.8.5";
  #     src = super.fetchFromGitHub {
  #       owner = "stevegrubb";
  #       repo = "libcap-ng";
  #       tag = "v0.8.5";
  #       hash = "sha256-qcHIHG59PDPfPsXA1r4hG4QhK2qyE7AgXOwUDjIy7lE=";
  #     };
  #   });
  # })
]
