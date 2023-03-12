
locals {

    #### Формируем список данных, где будет фигурировать:
    #### Имена SG, новые имена Networks и CIDR от Networks
    ##->
    # [
    #   {
    #       teamA_backend = [
    #           "71d28fae:10.10.10.0/24",
    #           "59d20aa4:10.11.10.0/24",
    #         ]
    #     },
    #   {
    #       teamB_frontend = [
    #           "f18c2155:10.10.20.0/24",
    #           "5cd9162c:10.11.20.0/24",
    #           "b6a851a4:10.110.20.0/24",
    #         ]
    #     },
    # ]
    security_groups_network__name_cidr__flatten = flatten([
        for security_group in local.security_groups : {
            "${security_group.name}": flatten([
                for cidr in try(security_group.cidrs, []):
                    "${substr(sha256(cidr), 0, 10)}:${cidr}"
            ])
        }
    ])

    security_group_map = { for item in local.security_groups_network__name_cidr__flatten :
        keys(item)[0] => values(item)[0]
    }

    #### Формируем массив в котором подсети получают уникальные имена и находятся в одномерном массиве
    ##->
    # {
    #   "59d20aa4" = "10.11.10.0/24"
    #   "5cd9162c" = "10.11.20.0/24"
    #   "71d28fae" = "10.10.10.0/24"
    #   "b6a851a4" = "10.110.20.0/24"
    #   "f18c2155" = "10.10.20.0/24"
    # }
    networks_flatten = flatten([
        for security_group in local.security_groups_network__name_cidr__flatten: [
            for key, value in security_group: [
                value
            ]
        ]
    ])

    # Конвертация flatten в map
    networks_map = { for network in local.networks_flatten :
        keys   ({split(":",network)[0]: split(":",network)[1]})[0] => 
        values ({split(":",network)[0]: split(":",network)[1]})[0]
    }

    # Формируем массив данных, где будет фигурировать sgName, networkName(list) в виде строки
    # {
    #     teamA_backend = "71d28fae,59d20aa4"
    # },
    # {
    #     teamA_backend = "f18c2155,5cd9162c,b6a851a4"
    # },
    security_groups_network__name__flatten = flatten([
        for security_group in local.security_groups : {
            "${security_group.name}": join(",",flatten([
                for cidr in try(security_group.cidrs, []):
                    "${substr(sha256(cidr), 0, 10)}"
            ]))
        }
    ])

    # Конвертация flatten в map
    security_groups_network__name__map = { for item in local.security_groups_network__name__flatten :
        keys(item)[0] => values(item)[0]
    }

    #### Формирует список массивов в котором, указана исходная SG и набор правил, 
    #### которые открываются по прринципу ОТ -> ДО *sg_from подставляется автоматически
    ##->
    # [
    #     {
    #         "teamA_backend" = [
    #         {
    #             "description" = "Access from backend to frontend"
    #             "ports_to" = "80"
    #             "proto" = "tcp"
    #             "sg_from" = "teamA_backend"
    #             "sg_to" = "teamB_frontend"
    #         },
    #         ]
    #     },
    #     {
    #         "teamB_frontend" = []
    #     },
    # ]
    security_group_rules_flatten = flatten([
        for security_group in local.security_groups : {
            "${security_group.name}": flatten([
                for rule in try(security_group.rules, []):
                    merge(rule, {"sg_from": security_group.name})
            ])
        }
    ])

    #### Формируется список массивов с полным набором оперируемых правил
    ##->
    # [
    #     {
    #         "description" = "Access from backend to frontend"
    #         "ports_to" = "80"
    #         "proto" = "tcp"
    #         "sg_from" = "teamA_backend"
    #         "sg_to" = "teamB_frontend"
    #     },
    # ]
    all_rules_flatten = flatten([
        for security_group in local.security_group_rules_flatten: [
            for key, value in security_group: [
                value
            ]
        ]
    ])

    # Конвертация flatten в map с уникальным именем по входной паре FROM_SG:TO_SG
    all_rules_map = { for item in local.all_rules_flatten :
        "${item.sg_from}:${item.sg_to}" => item
    }

}