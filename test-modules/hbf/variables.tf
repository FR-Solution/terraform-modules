variable "security_groups" {
    default = []
    type    = list
}

locals {

    custom_security_group  = [
        {   
            name = "teamA_backend"
            cidrs = [
                # "${yandex_compute_instance.team-a-backend.network_interface[0].ip_address}/32"
                "10.0.0.0/24"
            ]
        },
        {
            name = "teamA_frontend"
            cidrs = [
                # "${yandex_compute_instance.team-a-frontend.network_interface[0].ip_address}/32"
                "10.0.1.0/24"
            ]
        }
    ]
}