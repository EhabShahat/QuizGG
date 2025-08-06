# Setup API Service Environment Variables
Write-Host "🔧 Setting up API service environment variables..." -ForegroundColor Cyan

# Generate or use existing secret key
$SECRET_KEY = "D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C"

# Set environment variables for API service
railway variables set SECRET_KEY="$SECRET_KEY"
railway variables set ROOT_ADDRESS="https://your-frontend-domain.up.railway.app"
railway variables set MAX_WORKERS="1"
railway variables set ACCESS_TOKEN_EXPIRE_MINUTES="30"
railway variables set SKIP_EMAIL_VERIFICATION="True"
railway variables set STORAGE_BACKEND="local"
railway variables set STORAGE_PATH="/app/data"
railway variables set VITE_CAPTCHA_ENABLED="false"

# These will be set automatically by Railway when you add the database services
Write-Host "⚠️  Remember to set these variables in Railway dashboard:" -ForegroundColor Yellow
Write-Host "DATABASE_URL=`${{Postgres.DATABASE_URL}}" -ForegroundColor Gray
Write-Host "REDIS=`${{Redis.REDIS_URL}}" -ForegroundColor Gray
Write-Host "MEILISEARCH_URL=http://`${{meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700" -ForegroundColor Gray

Write-Host "✅ API service variables set!" -ForegroundColor Green