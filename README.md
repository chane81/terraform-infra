# Infra

- Repository for IaC

## IAC

- iac folder - terraform code for Infra
- 폴더별 설명

  ```bash
  aws
  ├── environments
  │   ├── dev
  │   │   ├── bestion
  │   │   │   └── terragrunt.hcl
  │   │   ├── ecr
  │   │   │   └── terragrunt.hcl
  │   │   ├── eks
  │   │   │   └── terragrunt.hcl
  │   │   ├── ingress-rule
  │   │   │   └── terragrunt.hcl
  │   │   ├── vpc
  │   │   │   └── terragrunt.hcl
  │   │   ├── vpc-peering
  │   │   │   └── terragrunt.hcl
  │   │   └── env.hcl
  │   │
  │   ├── staging
  │   │   ├── ...
  │   │   ...
  │   └── prod
  │   │   ├── ...
  │   │   ...
  │
  ├── modules
  │       ├── bestion
  │       │   └── spec-file
  │       ├── ecr
  │       │   └── spec-file
  │       ├── eks
  │       │   └── spec-file
  │       ├── ingress-rule
  │       │   └── spec-file
  │       ├── vpc
  │       │   └── spec-file
  │       └── vpc-peering
  │           └── spec-file
  │
  ├── terragrunt.hcl

  ```

  - aws/environments/dev, prod, staging/~하위 리소스

    - 각 환경별 리소스를 생성하기 위한 terragrunt 파일이 위치합니다.
    - aws/modules 하위의 각 테라폼 리소스 생성 모듈이 각 환경별로 호출해 실행을 하게 됩니다.

  - aws/modules/~하위 리소스

    - 각 환경별로 리소스를 생성하기 위한 테라폼 공통 모듈 입니다.

  - aws/terragrunt.hcl
    - global적 input 요소 선언
    - remote state 및 dynamo lock 에 대한 선언

## Terragrunt

- 참고

  - 기존 terraform 으로 명령을 실행하여 plan, apply, destroy 를 하던것을 terragrunt 를 통해 plan, apply, destroy 를 합니다.
  - iac/aws 폴더(root) 에서 terragrunt 리소스에 대한 명령 수행 및 각 폴더별 리소스 관리가 가능합니다.
  - 초기 소스 다운로드 후에 init 을 하여 backend.tf 와 provider.tf 를 generate 합니다.
    ```bash
    $ cd iac/aws
    $ terragrunt run-all init
    ```

- 모듈별 리소스 설명

  - argocd
    - argocd 코드
  - bestion
    - 베스천 ec2 생성
  - ecr
    - aws ecr repo 생성
  - eks
    - aws eks 생성
  - ingress-rule
    - 인그레스 컨트롤러 설치 및 각 라우트 설정
    - route53 설정
  - vpc
    - vpc 생성
  - vpc-peering
    - vpc peering 연결 설정
    - partner center 의 신규생성 vpc 의 리소스 와 기존 사용하던 vpc 의 rds 와의 연결을 위해 peering 설정

- Command

  ```bash
  # format 정렬
  $ terragrunt hclfmt

  # init
  $ terragrunt run-all init

  # plan 수행
  $ terragrunt run-all plan

  # apply
  $ terragrunt run-all apply

  # debug
  $ terragrunt run-all apply --terragrunt-log-level debug --terragrunt-debug

  # render - render json 파일로 출력
  $ terragrunt render-json

  # graph
  $ terragrunt graph-dependencies
  ```

## 참고

- vpc-peering
  - accept 할 vpc id 기재
- ingress-rule
  - ssl 로 사용할 인증서 기재
