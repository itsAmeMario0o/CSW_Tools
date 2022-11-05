resource "tetration_scope" "scope" {
  short_name          = "Terraform created scope"
  short_query_type    = "eq"
  short_query_field   = "ip"
  short_query_value   = "10.0.0.1"
  parent_app_scope_id = "PASTE SCOPE ID HERE"
}
