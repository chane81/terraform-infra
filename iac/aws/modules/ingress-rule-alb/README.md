# Ingress 설정

## 설명

- alb ingress controller 를 사용하여 라우팅
- 테라폼으로 생성하는 리소스에(argocd, grafana, kiali 등) 대해 ingress rule 을 적용함
- application
  - application 의 경우 자주 바뀌거나 지속적으로 만들어야하는 경우이므로 독립적으로 manifest 소스(github 소스) 를 따로 만들어 github 에 올리고 argocd 를 통해 배포 프로세스를 타게 한다.
  - terraform-infra github 에서 application manifest 를 두지 않은 이유는 infra 와 application manifest 에 대한 github history 가 모두 나와 history 파악을 좀 더 용이 하게 하기 위해 분리함.
- flow
  - alb loadbalancer -> service -> pod
