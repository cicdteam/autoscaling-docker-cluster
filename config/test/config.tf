module "main" {
  source           = "../../tf"
  region           = "${var.region}"
  name             = "${var.name}"
  public_key_path  = "${var.public_key_path}"
}
