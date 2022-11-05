resource "tetration_scope" "internet" {
  short_name          = "INTERNET"
  short_query_value   = jsonencode( { "type": "not",
                      "filter": { "type": "or",
                                  "filters": [ { "type": "subnet",
                                                  "field": "ip",
                                                  "value": "10.0.0.0/8"},
                                                { "type": "subnet",
                                                  "field": "ip",
                                                  "value": "172.16.0.0/12"},
                                                { "type": "subnet",
                                                  "field": "ip",
                                                  "value": "192.168.0.0/16"}]}}
  )
  parent_app_scope_id = "PASTE SCOPE ID HERE" # Root Scope
}