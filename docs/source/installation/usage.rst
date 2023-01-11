Usage
=====

Installation
------------

To use Lumache, first install it using pip:

.. code-block:: bash

   cd base  && terraform init --upgrade && cd -
   cd k8s   && terraform init --upgrade && cd -

   # Настраивает базовое окружение для VAULT и KEYCLOAK

   terraform apply \
   -chdir=base \
   -auto-approve  \
   -state states/base

   export CLUSTER_NAME="example" 
   export VAULT_ADDRESS="http://vault.ru" 

   # Устанавливает кластер
   terraform apply \
   -chdir=k8s \
   -var cluster_name="${CLUSTER_NAME}" \
   -var vault_server="${VAULT_ADDRESS}"  \
   -auto-approve  \
   -state states/${CLUSTER_NAME}
