# firestore

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_schedule | Backup schedule. | <pre>object({<br>    retention         = string<br>    daily_recurrence  = optional(bool, false)<br>    weekly_recurrence = optional(string)<br>  })</pre> | `null` | no |
| database | Database attributes. | <pre>object({<br>    app_engine_integration_mode       = optional(string)<br>    concurrency_mode                  = optional(string)<br>    deletion_policy                   = optional(string)<br>    delete_protection_state           = optional(string)<br>    kms_key_name                      = optional(string)<br>    location_id                       = optional(string)<br>    name                              = string<br>    point_in_time_recovery_enablement = optional(string)<br>    type                              = optional(string)<br>  })</pre> | n/a | yes |
| database\_create | Flag indicating whether the database should be created of not. | `string` | `true` | no |
| documents | Documents. | <pre>map(object({<br>    collection  = string<br>    document_id = string<br>    fields      = any<br>  }))</pre> | `{}` | no |
| fields | Fields. | <pre>map(object({<br>    collection = string<br>    field      = string<br>    indexes = optional(list(object({<br>      query_scope  = optional(string)<br>      order        = optional(string)<br>      array_config = optional(string)<br>    })))<br>    ttl_config = optional(bool, false)<br>  }))</pre> | `{}` | no |
| indexes | Indexes. | <pre>map(object({<br>    api_scope  = optional(string)<br>    collection = string<br>    fields = list(object({<br>      field_path   = optional(string)<br>      order        = optional(string)<br>      array_config = optional(string)<br>      vector_config = optional(object({<br>        dimension = optional(number)<br>        flat      = optional(bool)<br>      }))<br>    }))<br>    query_scope = optional(string)<br>  }))</pre> | `{}` | no |
| project\_id | Project id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| firestore\_database | Firestore database. |
| firestore\_document\_ids | Firestore document ids. |
| firestore\_documents | Firestore documents. |
| firestore\_field\_ids | Firestore field ids. |
| firestore\_fields | Firestore fields. |
| firestore\_index\_ids | Firestore index ids. |
| firestore\_indexes | Firestore indexes. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->