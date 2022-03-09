
variable "name" {
  description = "The name of the function- must be unique for each account region."
  type        = string
}

variable "description" {
  description = "An optional description for the function."
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "How much memory to allocate to a function. CPU increases proportionally."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The time in seconds after which the function will be killed."
  type        = number
  default     = 3
}

variable "reserved_concurrent_executions" {
  description = "In general this should only be used for critical functions. https://docs.aws.amazon.com/lambda/latest/dg/configuration-concurrency.html."
  type        = number
  default     = null
}

variable "environment_variables" {
  description = "An object containing environmental variables in key/value structure."
  default     = {}
}


variable "principal_services" {
  description = "The list of services, besides the default lambda.amazonaws.com, which can directly trigger the Lambda. This is needed for things like Lambda@Edge, where Cloudfront needs access."
  type        = list(string)
  default     = []
}

variable "auto_deploy" {
  description = "If enabled new code upgrades will get deployed by the reload lambda"
  type        = bool
  default     = true
}

variable "tags" {
  description = "An object containing base tags for resources in this module."
  default     = {}
}



#
# Networking
#

variable "enable_networking" {
  default = true
}

variable "vpc_id" {
  description = "The VPC to launch the Lambda in."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The subnets to launch the Lambda in."
  type        = list(string)
  default     = null
}


#
# Packaging
#

variable "use_image" {
  description = "Use a container image instead of a file for the lambda."
  type        = bool
  default     = true
}

variable "image_uri" {
  description = "The URI of the image."
  type        = string
  default     = null
}

# S3 Settings

variable "s3_bucket" {
  description = "The bucket containing the function code."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "The key for the function code."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "The object version for the function code. Only used on versioned buckets."
  type        = string
  default     = null
}

# File Settings

variable "function_source" {
  description = "A string to turn into a Lambda function. SHould only be used for small functions."
  type        = string
  default     = null
}

# S3 and File settings

variable "source_code_hash" {
  description = "The optional source code hash of the lambda code (either locally or in a bucket) to force an upgrade."
  type        = string
  default     = null
}

variable "runtime" {
  description = "The runtime to use if a file based package is used."
  type        = string
  default     = null
}
