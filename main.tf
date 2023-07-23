resource "okta_app_saml" "example" {
  label                    = "tf-example"
  sso_url                  = "https://example.com"
  recipient                = "https://example.com"
  destination              = "https://example.com"
  audience                 = "https://example.com/audience"
  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = false
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  attribute_statements {
    type         = "GROUP"
    name         = "groups"
    filter_type  = "REGEX"
    filter_value = ".*"
  }
}

resource "okta_group" "example" {
  name        = "tf-example"
  description = "My Example Group"
}

data "okta_group" "example" {
  name = "tf-example"
  depends_on = [okta_group.example]
}

resource "okta_app_group_assignment" "example" {
  app_id   = okta_app_saml.example.id
  group_id = data.okta_group.example.id
}
