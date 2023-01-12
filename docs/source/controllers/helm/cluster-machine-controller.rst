cluster-machine-controller
==========================
.. tabs::
  .. group-tab:: YC

    .. code-block:: shell-session

        helm repo add fraima helm.fraima.io
        helm repo update fraima

  .. group-tab:: AWS

    .. code-block:: shell-session

        helm repo add

  .. group-tab:: GCP

    .. code-block:: shell-session

        helm repo add

machine-group
-------------
.. seealso::

   Component :py:mod:`machine-group`
      Добавления новой группы машин производится с помощью чарта ниже, а для дополнительной кастомизации machine-group,
      воспользуйтесь базовым `Values.yaml <https://github.com/fraima/fraima-charts/blob/main/helm-chart-sources/machine-group/values.yaml>`_

.. warning::
  При создании провайдера, указывается секрет для доступа к облаку, если ссылка на него будет некорректная,
  то cluster-machine-controller упадет с ошибкой PANIC.

.. tabs::
  .. group-tab:: YC

    .. code-block:: shell-session

      MACHINE_GROUP_INSTANCE_NAME=monitoring
      MACHINE_GROUP_INSTANCE_REPLICAS=1

      MACHINE_GROUP_CLOUD_BOOT_IMG_ID=""
      MACHINE_GROUP_CLOUD_SUBNET_ID=""
      MACHINE_GROUP_CLOUD_ZONE_NAME=ru-central1-a

      MACHINE_CONTROLLER_NAMEPACE=fraima-ccm

      MACHINE_PROVIDER_NAME="yandex-cloud"
      MACHINE_PROVIDER_TYPE=YandexCloud

      K8S_API_URL=""
      K8S_API_PORT=443

      helm repo add fraima helm.fraima.io
      helm repo update fraima
      helm upgrade $MACHINE_GROUP_INSTANCE_NAME fraima/machine-group \
      --namespace $MACHINE_CONTROLLER_NAMEPACE \
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