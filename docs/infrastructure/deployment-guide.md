# Veil Deployment Guide

## Local Development
```bash
docker-compose up --build
```

## Kubernetes Deployment
- Apply manifests from `infrastructure/kubernetes`
- Configure TLS with Let's Encrypt
- Set environment variables in ConfigMaps

## Monitoring Setup
- Prometheus for metrics
- Grafana dashboards for visualization
```
