#!/bin/bash
#
# use kubeval to validate helm generated kubernetes manifest
#

set -o errexit
set -o pipefail

CHART_DIRS="$(git diff --name-only remotes/origin/master | grep '[cC]hart.yaml' | sed -e 's#/[Cc]hart.yaml##g')"

helm repo add bitnami https://charts.bitnami.com
helm repo add elastic https://helm.elastic.co

for CHART_DIR in ${CHART_DIRS};do
  echo "helm dependency build..."
  helm dependency build "${CHART_DIR}"

  echo "kubeval(idating) ${CHART_DIR##charts/} chart..."
  helm template "${CHART_DIR}" | kubeval
done
