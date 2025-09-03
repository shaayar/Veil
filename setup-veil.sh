#!/bin/bash

echo "🚀 Setting up Veil Project Structure in the current folder..."

# -----------------------------
# 0. Detect Best Package Manager
# -----------------------------
if command -v pnpm &> /dev/null; then
    PKG_MANAGER="pnpm"
    echo "✅ Using pnpm (fastest & recommended)"
else
    PKG_MANAGER="npm"
    echo "⚠️ pnpm not found. Falling back to npm."
    echo "💡 Install pnpm later for faster performance: npm install -g pnpm"
fi

# -----------------------------
# 1. Create Complete Folder Structure
# -----------------------------
mkdir -p veil-frontend/public \
         veil-frontend/src/{components/{auth,chat,rooms,ui},hooks,services,stores,types,utils} \
         veil-backend/src/{controllers,middleware,services/{auth,messaging,rooms,security},websocket,models,utils,config} \
         veil-backend/tests/{unit,integration,security} \
         security/{crypto,validation,audit,memory} \
         infrastructure/{kubernetes/{deployments,services,configmaps},docker,terraform/modules,monitoring/grafana-dashboards,scripts} \
         docs/{architecture/{diagrams},api,security,infrastructure}

# -----------------------------
# 2. Setup Frontend (React + Vite + TS + Tailwind)
# -----------------------------
echo "⚡ Setting up Veil Frontend..."

cd veil-frontend
$PKG_MANAGER create vite@latest . -- --template react-ts

# Install dependencies
$PKG_MANAGER add tailwindcss postcss autoprefixer @tailwindcss/forms @tailwindcss/typography @heroicons/react react-router-dom axios zustand

# Initialize Tailwind
npx tailwindcss init -p

# Configure Tailwind
cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html","./src/**/*.{js,ts,jsx,tsx}"],
  theme: { extend: {} },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
}
EOL

cd ..

# -----------------------------
# 3. Setup Backend (Node + Express + TS + Socket.IO)
# -----------------------------
echo "🛠️ Setting up Veil Backend..."

cd veil-backend
$PKG_MANAGER init -y

# Install dependencies
$PKG_MANAGER add express socket.io cors dotenv redis
$PKG_MANAGER add -D typescript ts-node nodemon @types/node @types/express @types/cors @types/socket.io

# Initialize TypeScript
npx tsc --init

# Create tsconfig.json
cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "rootDir": "src",
    "outDir": "dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
EOL

# Create server.ts
mkdir -p src
cat > src/server.ts <<EOL
import express from "express";
import http from "http";
import { Server } from "socket.io";
import cors from "cors";

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

app.use(cors());
app.use(express.json());

io.on("connection", (socket) => {
    console.log("⚡ New client connected:", socket.id);
    socket.on("disconnect", () => console.log("❌ Client disconnected:", socket.id));
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(\`🚀 Veil Backend running on http://localhost:\${PORT}\`));
EOL

cd ..

# -----------------------------
# 4. Setup ESLint + Prettier
# -----------------------------
echo "✨ Setting up ESLint & Prettier..."

cd veil-frontend
$PKG_MANAGER add -D eslint prettier eslint-plugin-react eslint-plugin-react-hooks eslint-config-prettier eslint-plugin-jsx-a11y @typescript-eslint/eslint-plugin @typescript-eslint/parser
cd ..

cd veil-backend
$PKG_MANAGER add -D eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier eslint-plugin-node
cd ..

# -----------------------------
# 5. Create Docker Compose Setup
# -----------------------------
mkdir -p infrastructure/docker
cat > infrastructure/docker/docker-compose.yml <<EOL
version: "3.9"
services:
  frontend:
    build: ./veil-frontend
    ports:
      - "3000:3000"
    command: $PKG_MANAGER run dev
    volumes:
      - ./veil-frontend:/app
      - /app/node_modules

  backend:
    build: ./veil-backend
    ports:
      - "5000:5000"
    command: $PKG_MANAGER run dev
    volumes:
      - ./veil-backend:/app
      - /app/node_modules
    environment:
      - REDIS_HOST=redis

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
EOL

# -----------------------------
# 6. Setup Documentation Structure
# -----------------------------
echo "📝 Creating Documentation Structure..."

# Root-level docs
cat > docs/README.md <<EOL
# Veil Documentation

Welcome to the Veil project docs!  
This repository contains technical, security, API, and deployment documentation.

## Structure
- **architecture/** → System design, data flow & diagrams
- **api/** → API endpoints & schemas
- **security/** → Encryption details & audit reports
- **infrastructure/** → Deployment & monitoring guides
EOL

# Architecture docs
cat > docs/architecture/overview.md <<EOL
# Veil System Architecture

This document explains the high-level architecture of Veil.

- **Frontend** → React + Vite + TailwindCSS + Signal Protocol
- **Backend** → Node.js + Express + WebSocket + Redis
- **Security** → Zero-knowledge encryption & ephemeral storage
- **Infrastructure** → Docker + Kubernetes + Terraform
EOL

touch docs/architecture/data-flow.md
touch docs/architecture/system-design.md

# API docs
cat > docs/api/endpoints.md <<EOL
# Veil API Endpoints

## Authentication
- POST /auth/anonymous → Anonymous login
- GET /auth/session → Fetch current session

## Messaging
- POST /message/send → Send encrypted message
- GET /message/:id → Retrieve message metadata

## Rooms
- POST /room/create → Create a temporary room
- GET /room/:id → Join a room
EOL

touch docs/api/schemas.md

# Security docs
cat > docs/security/encryption.md <<EOL
# Veil Encryption Overview

Veil uses **Signal Protocol** for end-to-end encryption:
- Curve25519 (ECDH key exchange)
- ChaCha20-Poly1305 (message encryption)
- HMAC-SHA256 (authentication)
- Perfect Forward Secrecy (key rotation)

Server **cannot decrypt** any user message.
EOL

touch docs/security/audit-reports.md

# Infrastructure docs
cat > docs/infrastructure/deployment-guide.md <<EOL
# Veil Deployment Guide

## Local Development
\`\`\`bash
$PKG_MANAGER run dev
\`\`\`

## Kubernetes Deployment
- Apply manifests from \`infrastructure/kubernetes\`
- Configure TLS with Let's Encrypt
- Set environment variables in ConfigMaps

## Monitoring Setup
- Prometheus for metrics
- Grafana dashboards for visualization
\`\`\`
EOL

touch docs/infrastructure/docker-guide.md
touch docs/infrastructure/kubernetes-guide.md
touch docs/infrastructure/monitoring.md

# -----------------------------
# 7. Final Message
# -----------------------------
echo "✅ Veil Project Setup Completed Successfully!"
echo "➡ Frontend: cd veil-frontend && $PKG_MANAGER run dev"
echo "➡ Backend:  cd veil-backend && $PKG_MANAGER run dev"
echo "➡ Docs:     open docs/README.md"
