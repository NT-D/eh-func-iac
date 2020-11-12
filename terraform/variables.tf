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
    name          = string
    maxBatchSize  = number
    prefetchCount = number
  }))
  default = [
    {
      name          = "func1"
      maxBatchSize  = 256
      prefetchCount = 512
    },
    {
      name          = "func2"
      maxBatchSize  = 256
      prefetchCount = 512
    }
  ]
}
