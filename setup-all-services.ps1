# Complete Railway Setup Script
Write-Host "🚀 Setting up all Railway services for ClassQuiz" -ForegroundColor Green

$SECRET_KEY = "D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C"

Write-Host "🔑 Using SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow
Write-Host ""

# Try to set up the main API service (the one we just deployed)
Write-Host "🔧 Setting up main service environment variables..." -ForegroundColor Cyan

try {
    # Set core environment variables
    railway variables set SECRET_KEY="$SECRET_KEY"
    railway variables set ROOT_ADDRESS="https://your-frontend-domain.up.railway.app"
    railway variables set MAX_WORKERS="1"
    railway variables set ACCESS_TOKEN_EXPIRE_MINUTES="30"
    railway variables set SKIP_EMAIL_VERIFICATION="True"
    railway variables set STORAGE_BACKEND="local"
    railway variables set STORAGE_PATH="/app/data"
    railway variables set VITE_CAPTCHA_ENABLED="false"
    
    Write-Host "✅ Core variables set!" -ForegroundColor Green
    
    # Note: These need to be set manually in Railway dashboard
    Write-Host ""
    Write-Host "⚠️  Set these variables manually in Railway dashboard:" -ForegroundColor Yellow
    Write-Host "DATABASE_URL=`${{Postgres.DATABASE_URL}}" -ForegroundColor Gray
    Write-Host "REDIS=`${{Redis.REDIS_URL}}" -ForegroundColor Gray
    Write-Host "MEILISEARCH_URL=http://localhost:7700" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Failed to set variables. You may need to set them manually in Railway dashboard." -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Manual Setup Required:" -ForegroundColor Cyan
Write-Host "1. Go to Railway dashboard" -ForegroundColor White
Write-Host "2. Find your API service (the one currently deploying)" -ForegroundColor White
Write-Host "3. Go to Variables tab and add the missing variables" -ForegroundColor White
Write-Host "4. Create frontend and worker services from your GitHub repo" -ForegroundColor White
Write-Host "5. Set up their environment variables" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "- Wait for current deployment to complete" -ForegroundColor White
Write-Host "- Check if the line ending issue is resolved" -ForegroundColor White
Write-Host "- Set up remaining services" -ForegroundColor White
Write-Host ""
Write-Host "💡 Your SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow