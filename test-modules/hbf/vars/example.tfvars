
security_groups  = [
    {   
        # Security Groups описываются только своей команды
        name = "teamA_backend"
        # Данный список может наполняться любым удобным методом,
        # главное передать в CIDRS переменную type=list
        cidrs = [
            # "${yandex_compute_instance.team-a-backend.network_interface[0].ip_address}/32"
            # "10.10.10.0/24",
            # "10.11.10.0/24",
        ]
        # Правила прописываются по принципу FROM -> TO
        rules = [
            # Несколько массивов в одну сторону не поддерживается, получите ошибку
            # Error: Duplicate object key
            {
                sg_to       = "teamA_frontend"  # Должна существовать на момент формирования правила.
                access = [
                    {
                        description = "access from teamA_backend to teamA_frontend"
                        protocol    = "tcp"
                        # ports_from  = [
                        #     5000
                        # ]
                        ports_to    = [
                            80,
                            443,
                            8080
                            
                        ]
                    }
                ]
            },
            {
                sg_to       = "hbf-server"  # Должна существовать на момент формирования правила.
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
            # "${yandex_compute_instance.team-a-frontend.network_interface[0].ip_address}/32"
            # "10.10.20.0/24",
            # "10.11.20.0/24",
            # "10.110.20.0/24",
        ]
        rules = [
            {
                sg_to       = "hbf-server"  # Должна существовать на момент формирования правила.
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
                sg_to       = "teamA_backend"  # Должна существовать на момент формирования правила.
                access = [
                    {
                        description = "access from teamA_backend to hbf-server"
                        protocol    = "tcp"
                        ports_to    = [
                            22
                        ]
                    }
                ]
            },
            {
                sg_to       = "teamA_frontend"  # Должна существовать на момент формирования правила.
                access = [
                    {
                        description = "access from teamA_backend to hbf-server"
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
