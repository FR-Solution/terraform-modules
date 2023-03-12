locals {
    security_groups  = [
        {
            name = "teamA_backend"
            cidrs = [
                "10.10.10.0/24",
                "10.11.10.0/24",
            ]
            rules = [
                {
                    description = "Access from backend to frontend by 80/TCP"
                    proto       = "tcp"
                    sg_to       = "teamB_frontend"
                    ports_to    = "80"
                },
                {
                    description = "Access from backend to frontend by 443/TCP"
                    proto       = "tcp"
                    sg_to       = "teamB_frontend"
                    ports_to    = "443"
                },
            ]
        },
        {
            name = "teamB_frontend"
            cidrs = [
                "10.10.20.0/24",
                "10.11.20.0/24",
                "10.110.20.0/24",
            ]
            rules = []
        }
    ]
}