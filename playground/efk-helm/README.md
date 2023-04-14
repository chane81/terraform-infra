# EKF 구성

## Demo MSA Application

- git 소스 다운로드 후 manifest 적용

  - git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
    cd microservice-demo

  ```bash
  # apply
  kubectl apply -f ./release/kubernetes-manifests.yaml
  ```

## Bitnami Elasticsearch (with Kibana)

- helm

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install elasticsearch bitnami/elasticsearch \
  -n elastic --create-namespace \
  -f ./bitnami-elasticsearch-values.yaml
```

## Elasticsearch

- helm

```bash
$ helm repo add elastic https://helm.elastic.co
$ helm install elasticsearch elastic/elasticsearch \
  -n elastic --create-namespace \
  -f ./elasticsearch-values.yaml
```

- notes

  1. Watch all cluster members come up.
     $ kubectl get pods --namespace=es -l app=elasticsearch-master -w

  2. Retrieve elastic user's password.
     $ kubectl get secrets --namespace=es elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d

  3. Test cluster health using Helm test.
     $ helm --namespace=es test elasticsearch

## Kibana

- helm

```bash
$ helm repo add elastic https://helm.elastic.co
$ helm install kibana elastic/kibana \
  -n elastic --create-namespace \
  -f ./kibana-values.yaml
```

- notes

  1. Watch all containers come up.
     $ kubectl get pods --namespace=elastic -l release=my-kibana -w

  2. Retrieve the elastic user's password.
     $ kubectl get secrets --namespace=elastic elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d

  3. Retrieve the kibana service account token.
     $ kubectl get secrets --namespace=elastic my-kibana-kibana-es-token -ojsonpath='{.data.token}' | base64 -d

## Fluentd

- 아래는 fluentd 하나만 사용하는 방법으로 forwarder 는 데몬셋으로 각 node별 1개 (ex. node 2개면 2개가 존재)
- aggregator 는 1개로 forwarder 에서 오는 데이터를 취합하여 elasticsearch 로 데이터를 보낸다.
- helm

```bash
$ helm repo add fluent https://fluent.github.io/helm-charts

# forwarder, aggregator configmap
$ k apply -f fluentd-configmap.yaml

# fluentd create
$ helm install fluentd bitnami/fluentd \
 -n fluent --create-namespace \
 -f ./bitnami-fluentd-values.yaml
```

## Fluent-bit

- helm

```bash
$ helm repo add fluent https://fluent.github.io/helm-charts
$ helm install fluent-bit fluent/fluent-bit \
 -n fluent --create-namespace \
 -f ./helm/fluent-bit-values.yaml
```
