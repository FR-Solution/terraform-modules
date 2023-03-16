locals {

    security_groups  = [
        {
            name = "teamA_backend"
            cidrs = [
                "${yandex_compute_instance.team-a-backend.network_interface[0].ip_address}/32"
            ]
            rules = [
                {
                    sg_to  = "teamA_frontend"
                    access = [
                        {
                            description = "access from teamA_backend to teamA_frontend"
                            protocol    = "tcp"
                            ports_to    = [
                                80,
                                443
                            ]
                        }
                    ]
                },
                {
                    sg_to  = "hbf-server"
                    access = [
                        {
                            description = "access from teamA_backend to hbf-server"
                            protocol    = "tcp"
                            ports_to    = [
                                9000
                            ]
                        }
                    ]
                },

            ]
        },
        {
            name = "teamA_frontend"
            cidrs = [
                "${yandex_compute_instance.team-a-frontend.network_interface[0].ip_address}/32"
            ]
            rules = [
                {
                    sg_to   = "hbf-server"
                    access  = [
                        {
                            description = "access from teamA_backend to hbf-server"
                            protocol    = "tcp"
                            ports_to    = [
                                9000
                            ]
                        }
                    ]
                },
            ]
        },
        {
            name = "hbf-server"
            cidrs = [
                "193.32.219.99/32"
            ]
            rules = []
        },
        {
            name = "world"
            cidrs = [
                "176.0.0.0/8"
            ]
            rules = [
                {
                    sg_to  = "teamA_backend"
                    access = [
                        {
                            description = "access from world to teamA_backend by ssh"
                            protocol    = "tcp"
                            ports_to    = [
                                22
                            ]
                        },
                    ]
                },
                {
                    sg_to  = "teamA_frontend"
                    access = [
                        {
                            description = "access from world to teamA_frontend by ssh"
                            protocol    = "tcp"
                            ports_to    = [
                                22
                            ]
                        }
                    ]
                },
            ]
        }
    ]
}