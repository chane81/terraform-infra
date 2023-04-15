# argo-cd

## config map

- 아래 설정들은 모두 config map > argocd-cm 에 추가가 된다.

  ### enable helm 옵션

  - kustomize + helm 조합에 사용할 helm 빌드를 위해 config map 에 아래 추가
  - helm-values.yaml 에 config 항목
    ```yaml
    configs:
      cm:
        ...
        kustomize.buildOptions: --enable-helm
        ...
    ```

  ### github webhook

  - 기본적으로 argocd 는 github manifest 소스에 대해 3분 주기로 watch 하며 변경을 감지하는데, 경우에 따라 최장 3분을 기다려야 할 수도 있다.
  - github webhook 을 사용하면 github 에서 변경시 webhook 을 통해 argocd 배포를 바로 진행할 수 있다.
  - 아래는 설정 부분이다.
    - helm-values.yaml 에 config 항목
    ```yaml
    configs:
      secret:
        ...
        githubSecret: "xxxx"
        ...
    ```
