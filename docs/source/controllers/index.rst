Controllers
===========

.. hint::
    Тут приведен список доступных контроллеров в нашей сборке с описанием установки и некоторых нюансов.
    Мы составили инструкцию, как можно воспользоваться этими контроллерами без боли и маги (просто добавь воды =)

.. warning::
   ВАЖНО! Что бы установка прошла без проблем, следуйте этапам: 
      * [1] Настраиваем   `cluster-cloud-provider <helm/cluster-cloud-controller.html#cluster-cloud-provider>`_
      * [2] Устанавливаем `cluster-cloud-controller   <helm/cluster-cloud-controller.html#cluster-cloud-controller>`_
      * [3] Устанавливаем `cluster-csi-controller     <helm/cluster-csi-controller.html#cluster-cloud-controller>`_
      * [3] Устанавливаем `cluster-machine-controller <helm/cluster-machine-controller.html#cluster-cloud-controller>`_
   Индекс указывает на очередность выполнения

.. toctree::
      helm/cluster-cloud-controller 
      helm/cluster-csi-controller
      helm/cluster-machine-controller
