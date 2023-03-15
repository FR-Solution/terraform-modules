locals {
    security_groups  = [
        {   
            # Security Groups описываются только своей команды
            name = "teamA_backend"
            # Данный список может наполняться любым удобным методом,
            # главное передать в CIDRS переменную type=list
            cidrs = [
                "10.10.10.0/24",
                "10.11.10.0/24",
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
                                443
                            ]
                        }
                    ]
                },

            ]
        },
        {
            name = "teamA_frontend"
            cidrs = [
                "10.10.20.0/24",
                "10.11.20.0/24",
                "10.110.20.0/24",
            ]
            rules = []
        }
    ]
}
