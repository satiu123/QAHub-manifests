# your-project-manifests

这是所有 Kubernetes 应用配置的唯一可信源 (Single Source of Truth)。
变更通过 Git 提交，并由 Argo CD 自动同步到集群中。

## 目录结构

- `/apps/base`: 存放所有应用通用的、无环境差异的 Kubernetes YAML 模板。
- `/apps/overlays`: 存放每个环境（dev, staging, prod）的差异化配置。每个环境的 `kustomization.yaml` 文件是该环境的入口点。

## 如何使用

要预览某个环境的最终配置，请运行：
```bash
kustomize build apps/overlays/dev
```
