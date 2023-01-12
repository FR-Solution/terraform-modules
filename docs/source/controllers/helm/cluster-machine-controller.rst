Kubernetes node autoscaler
==========================
.. hint::
  При работе с кластером волей не волей приходится работать с нодам (обновлять, удалять, изменять и т.п).
  Конечно при малых объемах можно выполнять эти операции руками, но на больших инсталляция человекофактор 
  прогрессивно растет. Для этого реализован контроллер, который может подключаться к инфраструктуре и 
  заказывать нужную вам конфигурацю.



.. _node_management:
Preparing the environment
-------------------------
.. tabs::
  .. group-tab:: YC

    .. code-block:: shell-session

        MACHINE_GROUP_INSTANCE_NAME=monitoring
        MACHINE_GROUP_INSTANCE_REPLICAS=1

        MACHINE_GROUP_CLOUD_BOOT_IMG_ID=""
        MACHINE_GROUP_CLOUD_SUBNET_ID=""
        MACHINE_GROUP_CLOUD_ZONE_NAME=ru-central1-a

        MACHINE_CONTROLLER_CMC_NAMEPACE=fraima-ccm

        MACHINE_PROVIDER_NAME="yandex-cloud"
        MACHINE_PROVIDER_TYPE=YandexCloud

        K8S_API_URL=""
        K8S_API_PORT=443

        helm repo add fraima helm.fraima.io
        helm repo update fraima

  .. group-tab:: AWS

    .. code-block:: shell-session

  .. group-tab:: GCP

    .. code-block:: shell-session



Install cluster-machine-controller
--------------------------
.. tabs::
  .. group-tab:: YC

    .. code-block:: shell-session

        helm upgrade cluster-machine-controller fraima/cluster-machine-controller \
        --namespace $MACHINE_CM_CONTROLLER_NAMEPACE \
        --create-namespace \
        --install \
        --wait \
        --atomic \


  .. group-tab:: AWS

    .. code-block:: shell-session

        helm repo add

  .. group-tab:: GCP

    .. code-block:: shell-session

        helm repo add

Machine-group
-------------
.. seealso::
      Добавление новой группы машин производится с помощью чарта ниже, а для дополнительной кастомизации machine-group,
      воспользуйтесь базовым `Values.yaml <https://github.com/fraima/fraima-charts/blob/main/helm-chart-sources/machine-group/values.yaml>`_

.. warning::
  При создании провайдера, указывается секрет для доступа к облаку, если ссылка на него будет некорректная,
  то cluster-machine-controller упадет с ошибкой PANIC.
  Cама группа должна размещаться в том же Namespece, что и <cluster-machine-controller>. 

.. tabs::
  .. group-tab:: YC

    .. code-block:: shell-session

      helm upgrade $MACHINE_GROUP_INSTANCE_NAME fraima/machine-group \
      --namespace $MACHINE_CONTROLLER_CMC_NAMEPACE \
      --create-namespace \
      --install \
      --wait \
      --atomic \
      --set clusterUrl=$K8S_API_URL \
      --set clusterPort=$K8S_API_PORT \
      --set replicas=$MACHINE_GROUP_INSTANCE_REPLICAS \
      --set template.spec.bootDisk.imageID=$MACHINE_GROUP_CLOUD_BOOT_IMG_ID \
      --set template.spec.networkInterfaces.subnetID=$MACHINE_GROUP_CLOUD_SUBNET_ID \
      --set template.spec.networkInterfaces.zoneID=$MACHINE_GROUP_CLOUD_ZONE_NAME \
      --set template.spec.provider.type=$MACHINE_PROVIDER_TYPE \
      --set template.spec.provider.name=$MACHINE_PROVIDER_NAME

  
  .. group-tab:: AWS

  .. group-tab:: GCP

