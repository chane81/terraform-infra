# AutoScaling

## 부하발생

kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

## hpa watch

kubectl get hpa php-apache --watch
