# QAHub-manifests

这是 QAHub 项目所有 Kubernetes 应用配置的唯一可信源 (Single Source of Truth)。
变更通过 Git 提交，并由 Argo CD 自动同步到集群中。

## 目录结构

- `/apps/base`: 存放所有应用通用的、无环境差异的 Kubernetes YAML 模板。
- `/apps/infra`: 存放基础设施组件（如数据库、消息队列、监控等）的配置。
  - `/operators`: Kubernetes operators 和 controllers（如 ECK, Nginx Ingress）。
  - `/db-migrator`: 数据库迁移任务。
  - `/mariadb`, `/mongodb`, `/redis`: 数据库服务。
  - `/elasticsearch`: Elasticsearch 集群。
  - `/strimzi`, `/kafka`: Kafka 消息队列。
- `/apps/overlays`: 存放每个环境（dev, prod）的差异化配置。每个环境的 `kustomization.yaml` 文件是该环境的入口点。
- `/crds`: 存放自定义资源定义 (CRDs)。

## 部署

### 一键部署
TODO: 添加 Argo CD 一键部署

### 手动部署

先部署CRDs:
```bash
kubectl apply -k crds/
```

然后部署基础设施组件:
```bash
kustomize build --enable-alpha-plugins --enable-exec apps/infra | kubectl apply -f -
```

最后部署应用:
```bash
kustomize build --enable-alpha-plugins --enable-exec apps/overlays/dev | kubectl apply -f -
```



## 配置说明

- **镜像拉取策略**: 所有容器配置为 `imagePullPolicy: IfNotPresent`，优先使用本地镜像以减少网络依赖。
- **证书**: 使用自签名证书 (`selfsigned-issuer`) 适用于本地开发环境。
- **Ingress**: 配置了 GRPC 路由，支持四个微服务：user-service, qa-service, search-service, notification-service。

## 开发环境访问

在本地 minikube 环境中：
- 添加 hosts 映射: `192.168.49.2 api.qahub.com`
- 使用 NodePort 访问: `https://192.168.49.2:31305` (端口可能因部署而异)
- 或运行 `minikube tunnel` 获取 LoadBalancer IP
