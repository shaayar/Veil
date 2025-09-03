#!/usr/bin/env bash
set -euo pipefail

# setup-veil.sh
# Complete Veil scaffold: frontend (Vite+React+TS+Tailwind+PWA), backend (Node+Express+TS+Socket.IO), infra (Docker, k8s, terraform), docs, security folders, eslint/prettier, and .env templates.
#
# Usage:
#   chmod +x setup-veil.sh
#   ./setup-veil.sh
#
# Run this in the directory where you want the project created (it will create folders like veil-frontend, veil-backend, infrastructure, docs, etc).

echo "🚀 Veil full-project setup starting..."

# -----------------------------
# 0. Detect package manager (pnpm preferred)
# -----------------------------
PKG_MANAGER="npm"
if command -v pnpm &> /dev/null; then
  PKG_MANAGER="pnpm"
  echo "✅ Using pnpm as package manager"
else
  echo "⚠ pnpm not found. Falling back to npm. (To install pnpm: npm install -g pnpm)"
fi

# helper wrappers for add/install with pnpm vs npm
if [ "$PKG_MANAGER" = "pnpm" ]; then
  PM_ADD() { pnpm add "$@"; }
  PM_ADD_DEV() { pnpm add -D "$@"; }
  PM_INIT() { pnpm init -y; }
  PM_RUN_CMD() { pnpm run "$@"; }
  PM_CREATE_VITE() { pnpm create vite@latest "$@" -- --template react-ts; }
else
  PM_ADD() { npm install "$@"; }
  PM_ADD_DEV() { npm install -D "$@"; }
  PM_INIT() { npm init -y; }
  PM_RUN_CMD() { npm run "$@"; }
  PM_CREATE_VITE() { npx create-vite@latest "$@" -- --template react-ts; }
fi

# -----------------------------
# 1. Create folder structure
# -----------------------------
echo "📁 Creating folder structure..."
mkdir -p veil-frontend/public/icons \
         veil-frontend/src/{components/{auth,chat,rooms,ui},hooks,services,stores,types,utils,pwa} \
         veil-backend/src/{controllers,middleware,services/{auth,messaging,rooms,security},websocket,models,utils,config} \
         veil-backend/tests/{unit,integration,security} \
         security/{crypto,validation,audit,memory} \
         infrastructure/{kubernetes/{deployments,services,configmaps},docker,terraform/modules,monitoring/grafana-dashboards,scripts} \
         docs/{architecture/{diagrams},api,security,infrastructure} \
         scripts

# -----------------------------
# 2. Frontend scaffold: Vite + React + TS + Tailwind + PWA
# -----------------------------
echo "⚛️  Setting up veil-frontend (Vite + React + TypeScript + Tailwind + PWA)..."
cd veil-frontend

# Create Vite app non-interactively (template react-ts)
# use '.' as target directory (current folder)
# Pass '.' to ensure initialization in place
PM_CREATE_VITE "."

echo "📦 Installing frontend deps..."
# core libs + PWA plugin
PM_ADD react-router-dom axios zustand
PM_ADD tailwindcss postcss autoprefixer @tailwindcss/forms @tailwindcss/typography @heroicons/react vite-plugin-pwa

# create index.css and basic main.tsx and App.tsx if not present
cat > src/index.css <<'CSS'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* basic body styles */
html, body, #root {
  height: 100%;
}
body {
  font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
  background-color: #0f172a;
  color: #e6eef8;
}
CSS

# minimal main.tsx if not present
if [ ! -f src/main.tsx ]; then
cat > src/main.tsx <<'TS'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
TS
fi

# minimal App.tsx
if [ ! -f src/App.tsx ]; then
cat > src/App.tsx <<'TS'
import React from "react";

export default function App() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <main className="max-w-2xl p-6 bg-slate-800 rounded-xl shadow-lg">
        <h1 className="text-2xl font-bold text-white">Veil — Ephemeral Messaging (PWA)</h1>
        <p className="mt-2 text-slate-300">This is a starter UI. Replace with your app components.</p>
      </main>
    </div>
  );
}
TS
fi

# Tailwind config
cat > tailwind.config.js <<'JS'
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html","./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
};
JS

# Vite config with PWA plugin + path aliases
cat > vite.config.ts <<'TS'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { VitePWA } from "vite-plugin-pwa";
import path from "path";

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: "autoUpdate",
      includeAssets: ["favicon.ico", "robots.txt"],
      manifest: {
        name: "Veil",
        short_name: "Veil",
        description: "Ephemeral encrypted messaging platform",
        theme_color: "#0f172a",
        background_color: "#0f172a",
        display: "standalone",
        orientation: "portrait",
        start_url: "/",
        icons: [
          { src: "/icons/icon-192.png", sizes: "192x192", type: "image/png" },
          { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png" }
        ]
      },
      workbox: {
        runtimeCaching: [
          {
            urlPattern: /\/api\/.*/,
            handler: "NetworkFirst",
            options: {
              cacheName: "veil-api-cache",
              expiration: { maxEntries: 50, maxAgeSeconds: 300 }
            }
          }
        ]
      }
    })
  ],
  resolve: {
    alias: {
      "@components": path.resolve(__dirname, "./src/components"),
      "@hooks": path.resolve(__dirname, "./src/hooks"),
      "@services": path.resolve(__dirname, "./src/services"),
      "@utils": path.resolve(__dirname, "./src/utils")
    }
  },
  server: {
    port: 3000
  }
});
TS

# manifest.json
cat > public/manifest.json <<'JSON'
{
  "name": "Veil",
  "short_name": "Veil",
  "description": "Ephemeral encrypted messaging platform",
  "theme_color": "#0f172a",
  "background_color": "#0f172a",
  "display": "standalone",
  "start_url": "/",
  "icons": [
    {"src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png"},
    {"src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png"}
  ]
}
JSON

# generate placeholder icons (try ImageMagick convert; otherwise create empty files)
if command -v convert &> /dev/null; then
  convert -size 192x192 xc:"#0f172a" -gravity center -pointsize 32 -fill white -annotate 0 "V" public/icons/icon-192.png || touch public/icons/icon-192.png
  convert -size 512x512 xc:"#0f172a" -gravity center -pointsize 120 -fill white -annotate 0 "V" public/icons/icon-512.png || touch public/icons/icon-512.png
else
  touch public/icons/icon-192.png
  touch public/icons/icon-512.png
fi

# Create basic robots.txt and favicon placeholder
echo "User-agent: *" > public/robots.txt
touch public/favicon.ico

# Tailwind css entry already created as src/index.css
# Add package.json scripts (add start/dev/build scripts)
# Use package manager to create scripts via editing package.json
# This will work for both npm and pnpm
node - <<'NODE'
const fs = require('fs');
const path = 'package.json';
const pkg = JSON.parse(fs.readFileSync(path, 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts.dev = "vite";
pkg.scripts.build = "tsc && vite build";
pkg.scripts.preview = "vite preview --port 5000";
pkg.scripts.lint = "eslint \"src/**/*.{ts,tsx,js,jsx}\" --max-warnings=0 || true";
fs.writeFileSync(path, JSON.stringify(pkg, null, 2));
NODE

# Install ESLint & Prettier dev deps for frontend (only packages, no init)
PM_ADD_DEV eslint prettier eslint-plugin-react eslint-plugin-react-hooks eslint-config-prettier eslint-plugin-jsx-a11y @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Create a basic .eslintrc.cjs
cat > .eslintrc.cjs <<'ESLINT'
module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  parserOptions: { ecmaVersion: 2020, sourceType: "module", ecmaFeatures: { jsx: true } },
  env: { browser: true, es2021: true, node: true },
  plugins: ["@typescript-eslint", "react", "react-hooks", "jsx-a11y"],
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:jsx-a11y/recommended",
    "prettier"
  ],
  settings: { react: { version: "detect" } },
  rules: { "react/react-in-jsx-scope": "off" }
};
ESLINT

cat > .prettierrc <<'PRET'
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100
}
PRET

# .gitignore for frontend
cat > .gitignore <<'GITIGNORE'
node_modules
dist
.env
.vscode
.DS_Store
GITIGNORE

cd ..

# -----------------------------
# 3. Backend scaffold: Express + Socket.IO + TypeScript
# -----------------------------
echo "🧩 Setting up veil-backend (Node + Express + Socket.IO + TypeScript)..."
cd veil-backend

PM_INIT

# Add runtime deps
PM_ADD express socket.io cors dotenv redis

# Add dev deps
PM_ADD_DEV typescript ts-node nodemon @types/node @types/express @types/cors @types/socket.io @types/redis eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier

# tsconfig.json - tuned for node server
cat > tsconfig.json <<'TS'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src"]
}
TS

# .env.example
cat > .env.example <<'ENV'
# Backend environment variables (copy to .env)
PORT=5000
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
JWT_SECRET=replace_with_strong_secret
NODE_ENV=development
ENV

# basic server.ts
mkdir -p src
cat > src/server.ts <<'NODE'
import express from "express";
import http from "http";
import { Server } from "socket.io";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*", methods: ["GET", "POST"] } });

app.use(cors());
app.use(express.json());

app.get("/health", (_req, res) => res.json({ ok: true }));

io.on("connection", (socket) => {
  console.log("⚡ New client connected:", socket.id);

  socket.on("message", (payload) => {
    // payload is expected to be encrypted; server routes it without decrypting
    console.log("→ message received (server routing):", payload && payload.type ? payload.type : "unknown");
    // echo example (replace with routing logic)
    socket.broadcast.emit("message", payload);
  });

  socket.on("disconnect", () => console.log("❌ Client disconnected:", socket.id));
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`🚀 Veil Backend running on http://localhost:${PORT}`));
NODE

# package.json scripts
node - <<'NODE'
const fs = require('fs');
const path = 'package.json';
const pkg = JSON.parse(fs.readFileSync(path));
pkg.scripts = pkg.scripts || {};
pkg.scripts.dev = "ts-node src/server.ts";
pkg.scripts.start = "node dist/server.js";
pkg.scripts.build = "tsc";
pkg.scripts.lint = "eslint \"src/**/*.{ts,js}\" --max-warnings=0 || true";
fs.writeFileSync(path, JSON.stringify(pkg, null, 2));
NODE

# ESLint config for backend
cat > .eslintrc.cjs <<'ESLINT'
module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint"],
  extends: ["eslint:recommended", "plugin:@typescript-eslint/recommended", "prettier"],
  env: { node: true, es2020: true }
};
ESLINT

cat > .prettierrc <<'PRET'
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100
}
PRET

# .gitignore for backend
cat > .gitignore <<'GITIGNORE'
node_modules
dist
.env
.vscode
.DS_Store
GITIGNORE

cd ..

# -----------------------------
# 4. Dockerfiles and docker-compose (local dev)
# -----------------------------
echo "🐳 Creating Dockerfiles and docker-compose for local development..."
# frontend Dockerfile
cat > infrastructure/docker/Dockerfile.frontend <<'DOCKF'
# Frontend Dockerfile (Vite dev server; for production build change to static serve)
FROM node:18-alpine AS base
WORKDIR /app
COPY veil-frontend/package.json veil-frontend/package-lock.json* veil-frontend/pnpm-lock.yaml* ./
RUN npm ci --production || true
COPY veil-frontend/ .
RUN npm install
EXPOSE 3000
CMD ["npm", "run", "dev"]
DOCKF

# backend Dockerfile
cat > infrastructure/docker/Dockerfile.backend <<'DOCKB'
FROM node:18-alpine AS base
WORKDIR /app
COPY veil-backend/package.json veil-backend/package-lock.json* veil-backend/pnpm-lock.yaml* ./
RUN npm ci --production || true
COPY veil-backend/ .
RUN npm install
EXPOSE 5000
CMD ["npm", "run", "dev"]
DOCKB

# docker-compose
cat > infrastructure/docker/docker-compose.yml <<'DC'
version: "3.9"
services:
  frontend:
    build:
      context: ../
      dockerfile: infrastructure/docker/Dockerfile.frontend
    ports:
      - "3000:3000"
    volumes:
      - ../veil-frontend:/app
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true

  backend:
    build:
      context: ../
      dockerfile: infrastructure/docker/Dockerfile.backend
    ports:
      - "5000:5000"
    volumes:
      - ../veil-backend:/app
      - /app/node_modules
    environment:
      - REDIS_HOST=redis
      - NODE_ENV=development

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
DC

# top-level .env for docker compose example
cat > infrastructure/docker/.env.example <<'ENV'
# Docker compose environment (copy to .env when using compose)
FRONTEND_PORT=3000
BACKEND_PORT=5000
REDIS_PORT=6379
ENV

# -----------------------------
# 5. Kubernetes manifests (skeleton, production-ready placeholders)
# -----------------------------
echo "☸️  Adding Kubernetes manifests (placeholders) in infrastructure/kubernetes..."
K8S_DIR="infrastructure/kubernetes"

# deployment frontend
cat > ${K8S_DIR}/deployments/frontend-deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: veil-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: veil-frontend
  template:
    metadata:
      labels:
        app: veil-frontend
    spec:
      containers:
        - name: veil-frontend
          image: veil/frontend:latest
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: veil-config
YAML

# service frontend
cat > ${K8S_DIR}/services/frontend-service.yaml <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: veil-frontend
spec:
  type: ClusterIP
  selector:
    app: veil-frontend
  ports:
    - port: 80
      targetPort: 80
YAML

# deployment backend
cat > ${K8S_DIR}/deployments/backend-deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: veil-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: veil-backend
  template:
    metadata:
      labels:
        app: veil-backend
    spec:
      containers:
        - name: veil-backend
          image: veil/backend:latest
          ports:
            - containerPort: 5000
          envFrom:
            - configMapRef:
                name: veil-config
YAML

# service backend
cat > ${K8S_DIR}/services/backend-service.yaml <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: veil-backend
spec:
  type: ClusterIP
  selector:
    app: veil-backend
  ports:
    - port: 5000
      targetPort: 5000
YAML

# redis deployment (stateful would be better in prod)
cat > ${K8S_DIR}/deployments/redis-deployment.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: veil-redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: veil-redis
  template:
    metadata:
      labels:
        app: veil-redis
    spec:
      containers:
        - name: redis
          image: redis:alpine
          ports:
            - containerPort: 6379
YAML

# configmap example
cat > ${K8S_DIR}/configmaps/veil-configmap.yaml <<'YAML'
apiVersion: v1
kind: ConfigMap
metadata:
  name: veil-config
data:
  APP_ENV: "production"
  FRONTEND_URL: "https://veil.example.com"
YAML

# secret template
cat > ${K8S_DIR}/configmaps/veil-secret-template.yaml <<'YAML'
# Fill values and kubectl apply -f after base64 encoding
apiVersion: v1
kind: Secret
metadata:
  name: veil-secrets
type: Opaque
data:
  JWT_SECRET: "<base64-jwt-secret>"
  REDIS_PASSWORD: "<base64-redis-password>"
YAML

# ingress placeholder (needs cluster ingress controller and TLS)
cat > ${K8S_DIR}/services/ingress.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: veil-ingress
  annotations:
    # Example annotation for cert-manager or cloud ingress; replace as needed
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
    - host: veil.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: veil-frontend
                port:
                  number: 80
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: veil-backend
                port:
                  number: 5000
YAML

# HorizontalPodAutoscaler example for backend
cat > ${K8S_DIR}/deployments/backend-hpa.yaml <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: veil-backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: veil-backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
YAML

# -----------------------------
# 6. Terraform skeleton (placeholders)
# -----------------------------
echo "🔧 Adding Terraform skeleton..."
TF_DIR="infrastructure/terraform"
cat > ${TF_DIR}/main.tf <<'TF'
# Terraform skeleton for Veil infrastructure
# Replace provider and modules for your cloud (AWS/GCP/DigitalOcean)
terraform {
  required_version = ">= 1.0"
}

provider "local" {
  # placeholder
}

# Example placeholder: create a namespace or resource group
# Add your cloud provider blocks and modules here
TF

cat > ${TF_DIR}/variables.tf <<'TF'
# Define variables for your environment
variable "region" {
  type    = string
  default = "us-east-1"
}
TF

cat > ${TF_DIR}/outputs.tf <<'TF'
# Outputs placeholder
output "example" {
  value = "veil-terraform-placeholder"
}
TF

# modules folder
mkdir -p ${TF_DIR}/modules

# -----------------------------
# 7. Docs structure + placeholders
# -----------------------------
echo "📚 Creating docs placeholders..."
cat > docs/README.md <<'MD'
# Veil Documentation

Welcome to the Veil docs. This directory contains system architecture, API references, security notes, and infrastructure guides.

- /architecture - system & data flow diagrams
- /api - API endpoints and schemas
- /security - encryption & audit notes
- /infrastructure - docker, kubernetes, terraform guides
MD

cat > docs/architecture/overview.md <<'MD'
# Architecture Overview

High-level description:
- Frontend: React + Vite + TypeScript (PWA)
- Backend: Node + Express + Socket.IO
- Ephemeral Storage: Redis (TTL based)
- Deployment: Docker Compose (local), Kubernetes + Terraform (production)
MD

cat > docs/api/endpoints.md <<'MD'
# API Endpoints (Overview)

## Health
GET /health

## Auth
POST /auth/anonymous - create/get anonymous session

## Messaging (encrypted payloads)
POST /message/send - send an encrypted message (routes only)
WS /socket - real-time messaging via WebSocket

## Rooms
POST /room/create
GET /room/:id
MD

touch docs/security/encryption.md
touch docs/infrastructure/deployment-guide.md

# -----------------------------
# 8. Security folder placeholders
# -----------------------------
echo "🔐 Creating security module placeholders..."
mkdir -p security/crypto security/validation security/audit security/memory
cat > security/crypto/README.md <<'MD'
# Crypto Module

Place implementations for Signal Protocol wrappers, key-management, and secure utilities here.
MD

cat > security/validation/README.md <<'MD'
# Validation Module

Input sanitizers, rate-limiting configs, and abuse detection helpers.
MD

# -----------------------------
# 9. Root README and .gitignore
# -----------------------------
echo "📝 Adding root README and .gitignore..."
cat > README.md <<'MD'
# Veil - Ephemeral Messaging (Scaffold)

This repository was scaffolded by setup-veil.sh.

Folders:
- veil-frontend: Vite + React + TypeScript + Tailwind + PWA
- veil-backend: Express + TypeScript + Socket.IO
- security: crypto and validation placeholders
- infrastructure: docker, kubernetes, terraform skeletons
- docs: documentation placeholders

Run (frontend):
> cd veil-frontend
> ${PKG_MANAGER} install
> ${PKG_MANAGER} run dev

Run (backend):
> cd veil-backend
> ${PKG_MANAGER} install
> ${PKG_MANAGER} run dev

Local Docker compose:
> cd infrastructure/docker
> docker compose up --build

Notes:
- Copy .env.example files and fill secrets
- Kubernetes manifests are placeholders — customize them before applying
MD

cat > .gitignore <<'GITIGNORE'
node_modules
dist
.env
.vscode
.DS_Store
GITIGNORE

# -----------------------------
# 10. Top-level helper scripts
# -----------------------------
echo "🛠 Adding helper scripts in scripts/ ..."
cat > scripts/start-local.sh <<'SH'
#!/usr/bin/env bash
# helper to start both frontend and backend (requires pnpm/nvm)
set -euo pipefail
echo "Starting veil frontend and backend (dev mode)..."
(cd veil-frontend && ${PKG_MANAGER} install && ${PKG_MANAGER} run dev) &
(cd veil-backend && ${PKG_MANAGER} install && ${PKG_MANAGER} run dev) &
wait
SH
chmod +x scripts/start-local.sh

# -----------------------------
# 11. Final notes
# -----------------------------
echo "✅ Veil scaffold complete!"
echo ""
echo "Next steps:"
echo "  1) Install dependencies:"
echo "     cd veil-frontend && ${PKG_MANAGER} install"
echo "     cd veil-backend && ${PKG_MANAGER} install"
echo "  2) Start dev servers:"
echo "     cd veil-frontend && ${PKG_MANAGER} run dev"
echo "     cd veil-backend && ${PKG_MANAGER} run dev"
echo "  3) Use infrastructure/docker/docker-compose.yml to run locally:"
echo "     cd infrastructure/docker && docker compose up --build"
echo ""
echo "Important:"
echo " - Kubernetes manifests (infrastructure/kubernetes) are placeholders; update images and secrets before deploying."
echo " - Fill veil-backend/.env (copy from veil-backend/.env.example) and secure JWT_SECRET for production."
echo ""

# exit to caller
exit 0
