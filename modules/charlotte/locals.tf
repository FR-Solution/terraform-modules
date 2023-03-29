
locals {

    #### Формируем список данных, где будет фигурировать:
    #### Имена SG, новые имена Networks и CIDR от Networks
    ##->
    #   [
    #     {
    #       "teamA_backend" = [
    #         "27ccd286ef:10.143.0.3/32",
    #       ]
    #     },
    #     {
    #       "teamA_frontend" = [
    #         "4894792f26:10.143.0.16/32",
    #       ]
    #     },
    #     {
    #       "hbf-server" = [
    #         "53503b3b29:193.32.219.99/32",
    #       ]
    #     },
    #     {
    #       "world" = [
    #         "06ee3732a5:176.0.0.0/8",
    #       ]
    #     },
    #   ]
    security_groups_network__name_cidr__flatten = flatten([
        for security_group in var.security_groups : {
            "${security_group.name}": flatten([
                for cidr in try(security_group.cidrs, []):
                    "${substr(sha256(cidr), 0, 10)}:${cidr}"
            ])
        }
    ])

    security_group_map = { for item in local.security_groups_network__name_cidr__flatten :
        keys(item)[0] => values(item)[0]
        if item != {}
    }

    #### Формируем массив в котором подсети получают уникальные имена и находятся в одномерном массиве
    ##->
    #   [
    #     "27ccd286ef: 10.143.0.3/32",
    #     "4894792f26: 10.143.0.16/32",
    #     "53503b3b29: 193.32.219.99/32",
    #     "06ee3732a5: 176.0.0.0/8",
    #   ]
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
    # [
    #     {
    #       "teamA_backend"   = "27ccd286ef"
    #     },
    #     {
    #       "teamA_frontend"  = "4894792f26"
    #     },
    #     {
    #       "hbf-server"      = "53503b3b29"
    #     },
    #     {
    #       "world"           = "06ee3732a5"
    #     },
    # ]
    security_groups_network__name__flatten = flatten([
        for security_group in var.security_groups : {
            "${security_group.name}": join(",",flatten([
                for cidr in try(security_group.cidrs, []):
                    "${substr(sha256(cidr), 0, 10)}"
            ]))
        }
    ])

    # Конвертация flatten в map
    security_groups_network__name__map = { for item in local.security_groups_network__name__flatten :
        keys(item)[0] => values(item)[0]
        if values(item)[0] != ""
    }

    #### Формирует список массивов в котором, указана исходная SG и набор правил, 
    #### которые открываются по прринципу ОТ -> ДО *sg_from подставляется автоматически
    ##->
    # [
    #     {
    #         "teamA_backend" = [
    #             {
    #                 "access" = [
    #                     {
    #                         "description" = "access from teamA_backend to teamA_frontend"
    #                         "ports_to" = tolist([
    #                             "80",
    #                             "443",
    #                         ])
    #                         "protocol" = "tcp"
    #                     },
    #                 ]
    #                 "sg_from" = "teamA_backend"
    #                 "sg_to" = "teamA_frontend"
    #             }
    #         ]
    #     },
    # ]
    security_group_rules_flatten = flatten([
        for security_group in var.security_groups : {
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
    #         "access" = [
    #             {
    #                 "description" = "access from teamA_backend to teamA_frontend"
    #                 "ports_to" = tolist([
    #                     "80",
    #                     "443",
    #                 ])
    #                 "protocol" = "tcp"
    #             },
    #         ]
    #         "sg_from" = "teamA_backend"
    #         "sg_to" = "teamA_frontend"
    #     },
    # ]
    rules_flatten = flatten([
        for security_group in local.security_group_rules_flatten: [
            for key, value in security_group: [
                value
            ]
        ]
    ])

    # Конвертация flatten в map с уникальным именем по входной паре FROM_SG:TO_SG
    rules_map = { for item in local.rules_flatten :
        "${item.sg_from}:${item.sg_to}" => item
    }

    #### Формирует список массивов для формирования уникального хеша для каждого правила в цепочке 5 Tuple
    ##-> $src_SG:$dst_SG:$src_ports:$dst_ports:$protocol
    # [
    #     {
    #     "96b84b011f" = {
    #         "access" = {
    #             "ports_from" = null
    #             "ports_to" = "80 443"
    #             "proto" = "tcp"
    #         }
    #         "sg_from" = "teamA_backend"
    #         "sg_to" = "teamA_frontend"
    #         }
    #     },
    # ]
    rules_access = flatten([
        for key, value in local.rules_flatten:{
            
            for access in value.access:
                substr(sha256("${try(value.sg_from, "")}:${try(value.sg_to, "")}:${join(",", try(access.ports_from, []))}"), 0, 10) => {
                "sg_from"   : value.sg_from
                "sg_to"     : value.sg_to
                "access"    : {
                    "ports_from": try(join(" ", access.ports_from), null)
                    "ports_to"  : try(join(" ", access.ports_to),   null)
                    "proto"     : access.protocol
                    }
                }
            
            
        }
    ])
    # Конвертация flatten в map с уникальным именем
    rules_access_map = { for item in local.rules_access :
        keys(item)[0] => values(item)[0]
        if item != {}
    }
}
