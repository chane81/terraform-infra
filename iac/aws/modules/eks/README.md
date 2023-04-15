# eks 생성 + 관련 리소스 생성

## stack

- eks
- istio
- kiali
- alb ingress controller
- meterics server (hpa를 위해 필수)
- prometheus
- grafana
- storage gp3
- eks autoscaling
- node(ec2) 별 key pair 설정

## 설명

- eks 를 생성합니다.
- eks 클러스터 auto scaling 을 위해 "eks-autoscaling" helm chart 를 설치 합니다.
- eks hpa 를 하기 위해 meterics server 가 필요하므로 "metrics-server" helm chart 를 통해 설치 합니다.
- 시스템 메트릭 수집 및 비쥬얼라이즈를 위해 prometheus, grafana 를 "kube-prometheus-stack" helm chart 를 통해 설치 합니다.
- istio 를 설치하고, kiali 도 설치합니다.
