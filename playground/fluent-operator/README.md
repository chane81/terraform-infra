# fluent operator

## default helm values get

```bash
$ helm show values fluent/fluent-operator --version 2.1.0 > values.yaml

$ helm install fluent-operator fluent/fluent-operator \
  -n fluent
  -f values.yaml
```
