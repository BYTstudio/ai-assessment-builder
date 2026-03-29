#!/bin/bash
# Push ai-assessment-builder to GitHub
# Usage: GITHUB_TOKEN=xxx GITHUB_USER=yourusername bash push-to-github.sh

set -e

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
GITHUB_USER="${GITHUB_USER:-}"
REPO_NAME="${REPO_NAME:-ai-assessment-builder}"

if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_USER" ]; then
    echo "ERROR: Set GITHUB_TOKEN and GITHUB_USER env vars first:"
    echo "  export GITHUB_TOKEN=ghp_xxxx"
    echo "  export GITHUB_USER=yourusername"
    echo "  bash push-to-github.sh"
    exit 1
fi

SKILL_DIR="/workspace-inner/.openclaw/extensions/feishu/skills/ai-assessment-builder"
TMP_DIR="/tmp/${REPO_NAME}"

# Clean old
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# Copy skill files
cp -r "$SKILL_DIR" "$TMP_DIR/"

# Copy React source (the actual assessment app)
cp -r /workspace/ai-assessment "$TMP_DIR/ai-assessment-app/"

# Create README
cat > "$TMP_DIR/README.md" << 'EOF'
# AI Assessment Builder

个人创业者AI转型成功率测评工具 — OpenClaw Skill + 完整React源码

## 内容

- `SKILL.md` — OpenClaw Skill（AI转型成功率测评构建器）
- `ai-assessment-app/` — 完整React源码，可直接部署

## 快速部署

```bash
cd ai-assessment-app
npm install
npm run build
# dist/ 目录部署到 https://minimaxi.com/space
```

## 安装 Skill

将 `SKILL.md` 复制到 OpenClaw skills 目录：
`~/.openclaw/skills/ai-assessment-builder/`

## 在线演示

- 测评工具：https://3kn60nw8nii1.space.minimaxi.com
- QR下载页：https://ejzhdpc4p8ao.space.minimaxi.com
EOF

cd "$TMP_DIR"

# Git init and push
git init -q
git add .
git commit -q -m "feat: AI转型成功率测评 builder skill + React源码

- OpenClaw skill (SKILL.md)
- 完整React + Vite + Tailwind + Recharts源码
- 15道情境题，5大维度，McKinsey级报告"

git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
git branch -M main
git push -qu main

echo "✅ 已推送到: https://github.com/${GITHUB_USER}/${REPO_NAME}"
rm -rf "$TMP_DIR"
