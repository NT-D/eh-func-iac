variable "app_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "hotpath_functions" {
  description = "Azure Functions list in hotpath"
  type = list(object({
    name             = string
    maxBatchSize     = number
    prefetchCount    = number
    ehn_capacity     = number
    ehn_max_capacity = number
    eh_partition     = number
    filter_disable   = bool
    label_disable    = bool
  }))
  default = [
    {
      name             = "filter"
      maxBatchSize     = 256
      prefetchCount    = 512
      ehn_capacity     = 2
      ehn_max_capacity = 8
      eh_partition     = 8
      filter_disable   = false
      label_disable    = true
    },
    {
      name             = "label"
      maxBatchSize     = 256
      prefetchCount    = 512
      ehn_capacity     = 2
      ehn_max_capacity = 8
      eh_partition     = 8
      filter_disable   = true
      label_disable    = false
    }
  ]
}
