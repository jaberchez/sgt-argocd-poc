#! /bin/bash

usage() {
   echo "Usage: $(basename $0) total-namespaces total-microservices-per-namespace"
   echo "Example: $(basename $0) 10 10"
   exit 1
}

createApp() {
   local namespace="$1"
   local idx="$2"

  cat <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${namespace}-helm-${idx}
  namespace: sanes-redhat-pre
spec:
  destination:
    namespace: ${namespace}
    server: https://kubernetes.default.svc
  project: default
  source:
    helm:
      valueFiles:
      - values-hello-world-sb01.yaml
      - values-hello-world-sb02.yaml
      - values-hello-world-sb03.yaml
    path: .
    repoURL: https://github.com/shellclear/helm-chart-umbrella-springboot.git
    targetRevision: multi-values
  syncPolicy:
    syncOptions:
      - ApplyOutOfSyncOnly=true
    automated:
      prune: true
      selfHeal: true
EOF
}

[ $# -ne 2 ] && usage

totalNamespaces=$1
totalMicroservicesPerNamespace=$2

for i in $(seq 1 ${totalNamespaces})
do
   namespace="demo${i}"

   for d in $(seq 1 ${totalMicroservicesPerNamespace})
   do
      #createApp $namespace ${d}
      createApp $namespace ${d} | oc apply -f -
   done
done


exit 0
