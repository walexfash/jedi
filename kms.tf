# Create KMS key
resource "aws_kms_key" "jedi_key" {
  description             = "Jedi KMS key"
  deletion_window_in_days = 7
}

