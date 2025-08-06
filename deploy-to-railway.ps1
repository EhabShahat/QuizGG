# ClassQuiz Railway Deployment Script (PowerShell)
# This script helps automate the Railway deployment process

Write-Host "🚂 ClassQuiz Railway Deployment Script" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Check if Railway CLI is installed
try {
    railway --version | Out-Null
} catch {
    Write-Host "❌ Railway CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "npm install -g @railway/cli" -ForegroundColor Yellow
    exit 1
}

# Check if user is logged in
try {
    railway whoami | Out-Null
} catch {
    Write-Host "🔐 Please log in to Railway first:" -ForegroundColor Yellow
    railway login
}

Write-Host "📋 This script will help you deploy ClassQuiz to Railway" -ForegroundColor Cyan
Write-Host "Make sure you have:" -ForegroundColor White
Write-Host "  ✅ A Railway account" -ForegroundColor Green
Write-Host "  ✅ Your code pushed to a Git repository" -ForegroundColor Green
Write-Host "  ✅ Environment variables ready" -ForegroundColor Green
Write-Host ""

$continue = Read-Host "Continue with deployment? (y/N)"
if ($continue -ne "y" -and $continue -ne "Y") {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit 0
}

# Generate a random secret key (PowerShell equivalent)
$SECRET_KEY = -join ((1..64) | ForEach {'{0:X}' -f (Get-Random -Max 16)})
Write-Host "🔑 Generated SECRET_KEY: $SECRET_KEY" -ForegroundColor Green
Write-Host "   (Save this for your environment variables)" -ForegroundColor Yellow
Write-Host ""

Write-Host "🏗️  Setting up Railway project..." -ForegroundColor Cyan

# Create new project or use existing
$newProject = Read-Host "Create new Railway project? (y/N)"
if ($newProject -eq "y" -or $newProject -eq "Y") {
    Write-Host "Creating new Railway project..." -ForegroundColor Cyan
    railway new
} else {
    Write-Host "Using existing project. Make sure you're in the right directory and linked to the correct project." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📝 Next steps to complete manually in Railway dashboard:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Add these services to your Railway project:" -ForegroundColor White
Write-Host "   - PostgreSQL (from service catalog)" -ForegroundColor Gray
Write-Host "   - Redis (from service catalog)" -ForegroundColor Gray
Write-Host "   - Meilisearch (custom Docker: getmeili/meilisearch:v0.28.0)" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Create these services from your repository:" -ForegroundColor White
Write-Host "   - API service (root directory, uses main Dockerfile)" -ForegroundColor Gray
Write-Host "   - Frontend service (frontend directory, uses frontend/Dockerfile)" -ForegroundColor Gray
Write-Host "   - Worker service (root directory, override command: arq classquiz.worker.WorkerSettings)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Set environment variables for API and Worker services:" -ForegroundColor White
Write-Host "   DATABASE_URL=`${{Postgres.DATABASE_URL}}" -ForegroundColor Gray
Write-Host "   REDIS=`${{Redis.REDIS_URL}}" -ForegroundColor Gray
Write-Host "   SECRET_KEY=$SECRET_KEY" -ForegroundColor Gray
Write-Host "   ROOT_ADDRESS=https://your-frontend-domain.up.railway.app" -ForegroundColor Gray
Write-Host "   MAX_WORKERS=1" -ForegroundColor Gray
Write-Host "   ACCESS_TOKEN_EXPIRE_MINUTES=30" -ForegroundColor Gray
Write-Host "   MEILISEARCH_URL=http://`${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700" -ForegroundColor Gray
Write-Host "   SKIP_EMAIL_VERIFICATION=True" -ForegroundColor Gray
Write-Host "   STORAGE_BACKEND=local" -ForegroundColor Gray
Write-Host "   STORAGE_PATH=/app/data" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Set environment variables for Frontend service:" -ForegroundColor White
Write-Host "   API_URL=http://`${{api.RAILWAY_PRIVATE_DOMAIN}}" -ForegroundColor Gray
Write-Host "   REDIS_URL=`${{Redis.REDIS_URL}}" -ForegroundColor Gray
Write-Host "   VITE_CAPTCHA_ENABLED=false" -ForegroundColor Gray
Write-Host "   NODE_ENV=production" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Generate public domain for frontend service" -ForegroundColor White
Write-Host "6. Update ROOT_ADDRESS in API service to match frontend domain" -ForegroundColor White
Write-Host ""
Write-Host "📖 For detailed instructions, see RAILWAY_DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 Happy deploying!" -ForegroundColor Green