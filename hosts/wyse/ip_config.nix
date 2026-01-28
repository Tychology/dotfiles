rec {
  prefix_length = 16;
  subnet = "10.0.0.0/${toString prefix_length}";
  gateway = "10.0.0.1";
  ip = "10.0.0.10";
  container_prefix = "10.0.1";
  dns = "${container_prefix}.1";
}
