{...}: {
  services.sopswarden = {
    enable = true;
    secrets = {
      # Simple secrets - just specify the Bitwarden item name
      pihole = "pihole";
      #   database-url = "Production Database";

      #   # Complex secrets - specify user, type, or field
      #   api-key = {
      #     name = "My Service";
      #     user = "admin@example.com";
      #   };
      #   ssl-cert = {
      #     name = "Certificates";
      #     type = "note";
      #     field = "ssl_cert";
      #   };
    };
  };
}
