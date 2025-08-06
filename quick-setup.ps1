# Quick Railway Setup
Write-Host "Setting up Railway services..." -ForegroundColor Green

$SECRET_KEY = "D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C"

Write-Host "Your SECRET_KEY: $SECRET_KEY" -ForegroundColor Yellow
Write-Host ""
Write-Host "Manual setup required:" -ForegroundColor Cyan
Write-Host "1. Go to Railway dashboard" -ForegroundColor White
Write-Host "2. Click on 'api' service -> Variables" -ForegroundColor White
Write-Host "3. Add the environment variables from DEPLOY_NOW.md" -ForegroundColor White
Write-Host "4. Repeat for 'worker' and 'frontend' services" -ForegroundColor White
Write-Host "5. Generate domain for frontend service" -ForegroundColor White
Write-Host ""
Write-Host "Environment variables to add:" -ForegroundColor Cyan
Write-Host "SECRET_KEY=$SECRET_KEY" -ForegroundColor Gray
Write-Host "DATABASE_URL=`${{Postgres.DATABASE_URL}}" -ForegroundColor Gray
Write-Host "REDIS=`${{Redis.REDIS_URL}}" -ForegroundColor Gray
Write-Host "And others from DEPLOY_NOW.md file" -ForegroundColor Gray