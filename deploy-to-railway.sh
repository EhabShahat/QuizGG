#!/bin/bash

# ClassQuiz Railway Deployment Script
# This script helps automate the Railway deployment process

set -e

echo "🚂 ClassQuiz Railway Deployment Script"
echo "======================================"

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Please install it first:"
    echo "npm install -g @railway/cli"
    exit 1
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please log in to Railway first:"
    railway login
fi

echo "📋 This script will help you deploy ClassQuiz to Railway"
echo "Make sure you have:"
echo "  ✅ A Railway account"
echo "  ✅ Your code pushed to a Git repository"
echo "  ✅ Environment variables ready"
echo ""

read -p "Continue with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 1
fi

# Generate a random secret key
SECRET_KEY=$(openssl rand -hex 32)
echo "🔑 Generated SECRET_KEY: $SECRET_KEY"
echo "   (Save this for your environment variables)"
echo ""

echo "🏗️  Setting up Railway project..."

# Create new project or use existing
read -p "Create new Railway project? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Creating new Railway project..."
    railway new
else
    echo "Using existing project. Make sure you're in the right directory and linked to the correct project."
fi

echo ""
echo "📝 Next steps to complete manually in Railway dashboard:"
echo ""
echo "1. Add these services to your Railway project:"
echo "   - PostgreSQL (from service catalog)"
echo "   - Redis (from service catalog)"
echo "   - Meilisearch (custom Docker: getmeili/meilisearch:v0.28.0)"
echo ""
echo "2. Create these services from your repository:"
echo "   - API service (root directory, uses main Dockerfile)"
echo "   - Frontend service (frontend directory, uses frontend/Dockerfile)"
echo "   - Worker service (root directory, override command: arq classquiz.worker.WorkerSettings)"
echo ""
echo "3. Set environment variables for API and Worker services:"
echo "   DATABASE_URL=\${{Postgres.DATABASE_URL}}"
echo "   REDIS=\${{Redis.REDIS_URL}}"
echo "   SECRET_KEY=$SECRET_KEY"
echo "   ROOT_ADDRESS=https://your-frontend-domain.up.railway.app"
echo "   MAX_WORKERS=1"
echo "   ACCESS_TOKEN_EXPIRE_MINUTES=30"
echo "   MEILISEARCH_URL=http://\${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700"
echo "   SKIP_EMAIL_VERIFICATION=True"
echo "   STORAGE_BACKEND=local"
echo "   STORAGE_PATH=/app/data"
echo ""
echo "4. Set environment variables for Frontend service:"
echo "   API_URL=http://\${{api.RAILWAY_PRIVATE_DOMAIN}}"
echo "   REDIS_URL=\${{Redis.REDIS_URL}}"
echo "   VITE_CAPTCHA_ENABLED=false"
echo "   NODE_ENV=production"
echo ""
echo "5. Generate public domain for frontend service"
echo "6. Update ROOT_ADDRESS in API service to match frontend domain"
echo ""
echo "📖 For detailed instructions, see RAILWAY_DEPLOYMENT.md"
echo ""
echo "🎉 Happy deploying!"