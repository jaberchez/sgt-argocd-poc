#! /bin/bash

createApp() {
   local namespace="$1"
   local idx="$2"

   cat <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${namespace}-raw-${d}
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

for i in {1..20}
do
   namespace="demo${i}"

   for d in {1..20}
   do
      #createApp $namespace ${d}
      createApp $namespace ${d} | oc apply -f -
   done
done


exit 0
