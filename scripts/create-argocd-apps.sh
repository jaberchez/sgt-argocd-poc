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
  name: ${namespace}-raw-${idx}
  namespace: argocd
spec:
  destination:
    namespace: ${namespace}
    server: https://kubernetes.default.svc
  project: default
  source:
    path: raw
    repoURL: https://github.com/jaberchez/sgt-argocd-poc.git
    targetRevision: demo${idx}-todel
  syncPolicy:
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
