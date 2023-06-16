#!/bin/zsh
TYPE=${1?}
NAMESPACE=${2:-`kubens -c`}

echo $TYPE
echo $NAMESPACE

kubectl --namespace $NAMESPACE rollout restart deployment $TYPE &
watch "kubectl  --namespace $NAMESPACE describe pod $TYPE | grep 'Image.*\:' | sed -r 's/(Image.*:).*\/$TYPE(.*)/\1\2/' "

#sed -r 's/foo (.*) bar/\1/'
