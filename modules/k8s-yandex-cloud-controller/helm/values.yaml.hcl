serviceAccountJSON: ${ base64encode(jsonencode(yandex_cloud_controller_sa.service_account_json)) }
folderID: ${ base64encode(yandex_cloud_controller_sa.folder_id) }

vpcID: ${ base64encode(yandex_cloud_controller_sa.vpc_id) }
routeTableID: ${ base64encode(yandex_cloud_controller_sa.route_table_id) }

clusterName: ${cluster_name}
podCIDR: ${pod_cidr}
k8sApiServer: ${k8s_api_server}
k8sApiServerPort: ${k8s_api_server_port}

${yamlencode(extra_values)}