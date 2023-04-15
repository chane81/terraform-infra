# EKF 구성

## 로깅 테스트용 데모 app 배포

```bash
# apply
kubectl apply -f ex-app.yaml
```

## Bitnami Elasticsearch (with Kibana)

- helm

  ```bash
  $ helm repo add bitnami https://charts.bitnami.com/bitnami
  $ helm install elasticsearch bitnami/elasticsearch \
    -n elastic --create-namespace \
    -f ./bitnami-elasticsearch-values.yaml

  # helm uninstall elasticsearch -n elastic
  ```

## Flentd + Fluent-bit 조합

- 설명

  - fluent-bit(데몬셋)는 forwarder 로써 각 node 별 1개씩 존재하며 컨테이너 로그를 가지고와서 fluentd 로 포워딩 한다.
  - fluentd 는 aggregator 로써 fluent-bit 로 받은 로그 데이터를 취합하여 elasticsearch 로 데이터를 보낸다.
  - fluentd, fluent-bit 비교
    - https://docs.fluentbit.io/manual/about/fluentd-and-fluent-bit
  - eks node 가 많아질 경우 fluent-bit 는 fluentd 에 비해 메모리 사용량이 매우 적기 때문에(~1MB, fluentd: ~60MB) collector 로써 fluent-bit를 사용하고 fluentd는 fluent-bit 에 비해 메모리 사용량은 많지만 플러그인이 상대적으로 많아(fluent-bit: 35개 가량, fluentd: 650개 이상) aggregator 로써 fluentd 를 사용하여 플러그인을 통한 데이터가공을 하는 구성을 하게 하여 좋은 조합을 만들어 낼 수 있다.

- helm

  - fluentd

    ```bash
    # namespace create & configmap 적용
    $ k create namespace fluent |
      k apply -f bitnami-fluentd-configmap.yaml

    # fluentd 생성
    $ helm install fluentd bitnami/fluentd \
    -n fluent --create-namespace \
    -f ./bitnami-fluentd-values.yaml

    # uninstall
    $ helm uninstall fluentd -n fluent
    ```

  - fluent-bit

    ```bash
    $ helm repo add fluent https://fluent.github.io/helm-charts

    # fluent-bit 생성
    $ helm install fluent-bit fluent/fluent-bit \
    -n fluent --create-namespace \
    -f ./fluent-bit-values.yaml
    ```
