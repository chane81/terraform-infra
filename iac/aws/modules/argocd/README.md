# argo-cd

## config map

- 아래 설정들은 모두 config map > argocd-cm 에 추가가 된다.

### enable helm 옵션

- 헬름차트 빌드를 위해 config map 에 아래 추가
- helm values 에 config 항목
  ```yaml
  kustomize.buildOptions: --enable-helm
  ```

### plugins

- kustomized-helm 추가
  - kustomize + helm 조합에 사용할 플러그인
  - helm values 에 config 항목에 추가
  ```yaml
  configManagementPlugins: |
    - name: kustomized-helm
      init:
        command: ["/bin/sh", "-c"]
        args: ["helm dependency build"]
      generate:
        command: [sh, -c]
        args: ["helm template --release-name release-name . > all.yaml && kustomize build"]
  ```
