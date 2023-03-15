variable "vultr_api_key" {
    description = "Vultr API key used to authenticate with Vultr."
}

variable "ts_node_regions" {
    description = "The Vultr region codes to deploy an instance to."
    type = list(string)
    default = ["syd"]
}

variable "ts_backend_server" {
    description = "The backend server with protocol where headscale is located"
}

variable "ts_preauth_key" {
    description = "Preauthentication key from headscale to automate process. If more than a single instance is provisioned then the '--reusable' flag needs to be included when generating the key."
}