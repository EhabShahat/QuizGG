# ClassQuiz Railway Setup Script
# Run this after creating services in Railway dashboard

Write-Host "🚂 ClassQuiz Railway Setup Script" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Generate secret key
$SECRET_KEY = -join ((1..64) | ForEach {'{0:X}' -f (Get-Random -Max 16)})
Write-Host "🔑 Generated SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow
Write-Host ""

Write-Host "📋 Setting up environment variables..." -ForegroundColor Cyan

# API Service Environment Variables
Write-Host "Setting up API service variables..." -ForegroundColor White

try {
    railway service api
    
    # Core configuration
    railway variables set SECRET_KEY="$SECRET_KEY"
    railway variables set ROOT_ADDRESS="https://your-frontend-domain.up.railway.app"
    railway variables set MAX_WORKERS="1"
    railway variables set ACCESS_TOKEN_EXPIRE_MINUTES="30"
    
    # Database and Redis (these will be auto-populated by Railway)
    railway variables set DATABASE_URL="`${{Postgres.DATABASE_URL}}"
    railway variables set REDIS="`${{Redis.REDIS_URL}}"
    
    # Meilisearch
    railway variables set MEILISEARCH_URL="http://`${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700"
    
    # Email (disabled for now)
    railway variables set SKIP_EMAIL_VERIFICATION="True"
    
    # Storage
    railway variables set STORAGE_BACKEND="local"
    railway variables set STORAGE_PATH="/app/data"
    
    # Optional features (disabled)
    railway variables set VITE_CAPTCHA_ENABLED="false"
    
    Write-Host "✅ API service variables set!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set API variables. Make sure 'api' service exists." -ForegroundColor Red
}

Write-Host ""

# Worker Service Environment Variables
Write-Host "Setting up Worker service variables..." -ForegroundColor White

try {
    railway service worker
    
    # Same as API service
    railway variables set SECRET_KEY="$SECRET_KEY"
    railway variables set ROOT_ADDRESS="https://your-frontend-domain.up.railway.app"
    railway variables set MAX_WORKERS="1"
    railway variables set ACCESS_TOKEN_EXPIRE_MINUTES="30"
    railway variables set DATABASE_URL="`${{Postgres.DATABASE_URL}}"
    railway variables set REDIS="`${{Redis.REDIS_URL}}"
    railway variables set MEILISEARCH_URL="http://`${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700"
    railway variables set SKIP_EMAIL_VERIFICATION="True"
    railway variables set STORAGE_BACKEND="local"
    railway variables set STORAGE_PATH="/app/data"
    
    Write-Host "✅ Worker service variables set!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set Worker variables. Make sure 'worker' service exists." -ForegroundColor Red
}

Write-Host ""

# Frontend Service Environment Variables
Write-Host "Setting up Frontend service variables..." -ForegroundColor White

try {
    railway service frontend
    
    railway variables set API_URL="http://`${{api.RAILWAY_PRIVATE_DOMAIN}}"
    railway variables set REDIS_URL="`${{Redis.REDIS_URL}}"
    railway variables set VITE_CAPTCHA_ENABLED="false"
    railway variables set NODE_ENV="production"
    
    Write-Host "✅ Frontend service variables set!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set Frontend variables. Make sure 'frontend' service exists." -ForegroundColor Red
}

Write-Host ""

# Meilisearch Service Environment Variables
Write-Host "Setting up Meilisearch service variables..." -ForegroundColor White

try {
    railway service meilisearch
    
    railway variables set MEILI_NO_ANALYTICS="true"
    
    Write-Host "✅ Meilisearch service variables set!" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to set Meilisearch variables. Make sure 'meilisearch' service exists." -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update ROOT_ADDRESS in API and Worker services with your actual frontend domain" -ForegroundColor White
Write-Host "2. Deploy each service using 'railway up' in the respective directories" -ForegroundColor White
Write-Host "3. Generate a public domain for your frontend service" -ForegroundColor White
Write-Host "4. Test your deployment!" -ForegroundColor White
Write-Host ""
Write-Host "💡 Your SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow
Write-Host "   Save this key - you'll need it if you redeploy!" -ForegroundColor Yellow