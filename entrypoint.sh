#!/bin/bash
# Inspired from https://gitlab.com/gitlab-examples/kubernetes-deploy/blob/master/src/common.bash
# thx !

# used vars and default values, if any
KUBE_URL=${KUBE_URL}
KUBE_TOKEN=${KUBE_TOKEN}
KUBE_NAMESPACE=${KUBE_NAMESPACE}

create_kubeconfig() {
  [[ -z "$KUBE_URL" ]] && return

  echo "Generating kubeconfig..."
  export KUBECONFIG="$(pwd)/kubeconfig"
  export KUBE_CLUSTER_OPTIONS=
  kubectl config set-cluster k8s-deploy --server="$KUBE_URL" \
    $KUBE_CLUSTER_OPTIONS
  kubectl config set-credentials k8s-deploy --token="$KUBE_TOKEN" \
    $KUBE_CLUSTER_OPTIONS
  kubectl config set-context k8s-deploy \
    --cluster=k8s-deploy --user=k8s-deploy \
    --namespace="$KUBE_NAMESPACE"
  kubectl config use-context k8s-deploy
  echo ""
}

ensure_deploy_variables() {
  if [[ -z "$KUBE_NAMESPACE" ]]; then
    echo "Missing KUBE_NAMESPACE."
    exit 1
  fi
}

ping_kube() {
  if kubectl version > /dev/null; then
    echo "Kubernetes is online!"
    echo ""
  else
    echo "Cannot connect to Kubernetes."
    return 1
  fi
}

ensure_deploy_variables
create_kubeconfig
ping_kube || exit 1


target=${1:-"/media/template"}
pattern=$(render.py $target | kubectl -n $KUBE_NAMESPACE apply -f - | grep "deployment")
if [ pattern != "" ]; then
  name=$(echo $pattern | sed -e 's/deployment "\([^"]\+\)".*/\1/g')
  kubectl -n $KUBE_NAMESPACE rollout status $name
fi

