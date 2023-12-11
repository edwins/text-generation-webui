variable "username" {
  type = string
  description = "username"
}

variable "project" {
  type = string
  description = "project name"
}

variable "region" {
  type = string
  description = "string, openstack region name; default = IU"
  default = "IU"
}

variable "instance_name" {
  type = string
  description = "name of instance"
}

variable "instance_count" {
  type = number
  description = "number of instances to launch"
  default = 1
}

variable "flavor" {
  type = string
  description = "flavor or size of instance to launch"
  default = "m1.tiny"
}

variable "keypair" {
  type = string
  description = "keypair to use when launching"
  default = ""
}

variable "power_state" {
  type = string
  description = "power state of instance"
  default = "active"
}

variable "user_data" {
  type = string
  description = "cloud init script"
  default = ""
}

variable "root_storage_source" {
  type = string
  description = "string, source currently supported is image; future values will include volume, snapshot, blank"
  default = "image"
}

variable "root_storage_type" {
  type = string
  description = "string, type is either local or volume"
  default = "local"
}

variable "root_storage_size" {
  type = number
  description = "number, size in GB"
  default = -1
}

variable "root_storage_delete_on_termination" {
  type = bool
  description = "bool, if true delete on termination"
  default = true
}

variable "proxy_auth_pass" {
  type = string
  description = "string, if proxy_api_or_app is 'app', and this is empty, then one will be generated and deposited into /opt/proxy-userpass.txt; should be set to a strong random string"
  default = ""
}

variable "proxy_expose_logfiles" {
  type = string
  description = "a comma separated list of log file locations to expose on the web, at /logs/ e.g. /var/log/mylog.log"
  default = ""
}