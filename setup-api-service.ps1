# Setup API Service Environment Variables
Write-Host "🔧 Setting up API service environment variables..." -ForegroundColor Cyan

# Generate or use existing secret key
$SECRET_KEY = "D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C"

# Link to API service (try different possible names)
$apiServiceNames = @("api", "classquiz-api", "backend", "main")
$apiLinked = $false

foreach ($serviceName in $apiServiceNames) {
    try {
        railway service $serviceName
        Write-Host "✅ Linked to $serviceName service" -ForegroundColor Green
        $apiLinked = $true
        break
    } catch {
        Write-Host "❌ Service $serviceName not found" -ForegroundColor Red
    }
}

if ($apiLinked) {
    Write-Host "Setting environment variables for API service..." -ForegroundColor White
    
    # Core configuration
    railway variables set SECRET_KEY="$SECRET_KEY"
    railway variables set ROOT_ADDRESS="https://your-frontend-domain.up.railway.app"
    railway variables set MAX_WORKERS="1"
    railway variables set ACCESS_TOKEN_EXPIRE_MINUTES="30"
    
    # Database and Redis connections
    railway variables set DATABASE_URL="`${{Postgres.DATABASE_URL}}"
    railway variables set REDIS="`${{Redis.REDIS_URL}}"
    
    # Search engine
    railway variables set MEILISEARCH_URL="http://localhost:7700"
    
    # Email configuration (disabled for now)
    railway variables set SKIP_EMAIL_VERIFICATION="True"
    
    # Storage configuration
    railway variables set STORAGE_BACKEND="local"
    railway variables set STORAGE_PATH="/app/data"
    
    # Feature flags
    railway variables set VITE_CAPTCHA_ENABLED="false"
    
    Write-Host "✅ API service environment variables set!" -ForegroundColor Green
    
    # Deploy the service
    Write-Host "🚀 Deploying API service..." -ForegroundColor Cyan
    railway up --detach
    
} else {
    Write-Host "❌ Could not find API service. Please check service name in Railway dashboard." -ForegroundColor Red
}

Write-Host ""
Write-Host "🔑 Your SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow
Write-Host "💡 Save this key for future deployments!" -ForegroundColor Yellow