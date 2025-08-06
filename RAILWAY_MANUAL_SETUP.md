# ClassQuiz Railway Manual Setup Guide

Since you already have a Railway project linked, follow these steps to deploy ClassQuiz:

## Step 1: Create Services in Railway Dashboard

Go to your Railway dashboard for project QuizGG and create these services:

### 1.1 Database Services (Already Done ✅)
- PostgreSQL ✅
- Redis ✅

### 1.2 Create Meilisearch Service
1. Click "New Service" → "Empty Service"
2. Name it "meilisearch"
3. Go to Settings → Environment
4. Add: `MEILI_NO_ANALYTICS=true`
5. Go to Settings → Deploy
6. Set Docker Image: `getmeili/meilisearch:v0.28.0`

### 1.3 Create API Service
1. Click "New Service" → "GitHub Repo"
2. Connect your ClassQuiz repository
3. Name it "api"
4. Root Directory: `/` (leave empty)
5. Build Command: (leave default)
6. Start Command: `./start.sh`

### 1.4 Create Frontend Service
1. Click "New Service" → "GitHub Repo"
2. Connect your ClassQuiz repository
3. Name it "frontend"
4. Root Directory: `frontend`
5. Build Command: `npm run build`
6. Start Command: `npm run run:prod`

### 1.5 Create Worker Service
1. Click "New Service" → "GitHub Repo"
2. Connect your ClassQuiz repository
3. Name it "worker"
4. Root Directory: `/` (leave empty)
5. Build Command: (leave default)
6. Start Command: `arq classquiz.worker.WorkerSettings`

## Step 2: Set Environment Variables

### 2.1 API Service Variables
```env
SECRET_KEY=D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS=${{Redis.REDIS_URL}}
ROOT_ADDRESS=https://your-frontend-domain.up.railway.app
MAX_WORKERS=1
ACCESS_TOKEN_EXPIRE_MINUTES=30
MEILISEARCH_URL=http://${{meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700
SKIP_EMAIL_VERIFICATION=True
STORAGE_BACKEND=local
STORAGE_PATH=/app/data
VITE_CAPTCHA_ENABLED=false
```

### 2.2 Worker Service Variables
Use the same variables as API service:
```env
SECRET_KEY=D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS=${{Redis.REDIS_URL}}
ROOT_ADDRESS=https://your-frontend-domain.up.railway.app
MAX_WORKERS=1
ACCESS_TOKEN_EXPIRE_MINUTES=30
MEILISEARCH_URL=http://${{meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700
SKIP_EMAIL_VERIFICATION=True
STORAGE_BACKEND=local
STORAGE_PATH=/app/data
```

### 2.3 Frontend Service Variables
```env
API_URL=http://${{api.RAILWAY_PRIVATE_DOMAIN}}
REDIS_URL=${{Redis.REDIS_URL}}
VITE_CAPTCHA_ENABLED=false
NODE_ENV=production
```

### 2.4 Meilisearch Service Variables
```env
MEILI_NO_ANALYTICS=true
```

## Step 3: Fix Line Endings Issue

The deployment failed due to Windows line endings. I've already fixed the `start.sh` file, but make sure to commit and push the changes:

```bash
git add start.sh
git commit -m "Fix line endings in start.sh for Railway deployment"
git push
```

## Step 4: Deploy Services

Deploy in this order:

1. **Meilisearch** (deploy first)
2. **PostgreSQL & Redis** (should auto-deploy)
3. **API Service** (deploy after databases are ready)
4. **Worker Service** (deploy after API is ready)
5. **Frontend Service** (deploy last)

## Step 5: Generate Public Domain

1. Go to Frontend service settings
2. Click "Generate Domain" or "Add Custom Domain"
3. Copy the generated domain (e.g., `frontend-production-xxxx.up.railway.app`)

## Step 6: Update ROOT_ADDRESS

1. Go to API service environment variables
2. Update `ROOT_ADDRESS` to your frontend domain
3. Go to Worker service environment variables
4. Update `ROOT_ADDRESS` to your frontend domain
5. Redeploy both services

## Step 7: Test Your Deployment

1. Visit your frontend domain
2. Try creating an account
3. Test creating a quiz
4. Verify all functionality works

## Alternative: Use PowerShell Script

Run the setup script I created:

```powershell
.\setup-railway-deployment.ps1
```

This will automatically set all environment variables if the services exist.

## Troubleshooting

### If API service fails to start:
- Check that PostgreSQL and Redis are running
- Verify environment variables are set correctly
- Check logs for specific errors

### If Frontend can't connect to API:
- Verify `API_URL` points to correct Railway private domain
- Check that API service is running and healthy

### If Worker service fails:
- Ensure it has the same environment variables as API
- Check Redis connection
- Verify the start command is correct

### If Meilisearch fails:
- Check the Docker image is correct: `getmeili/meilisearch:v0.28.0`
- Verify environment variable is set

## Production Recommendations

Once everything is working:

1. **Set up custom domain** for frontend
2. **Configure email settings** (set `SKIP_EMAIL_VERIFICATION=False`)
3. **Add external storage** (S3) for file uploads
4. **Set up monitoring** and alerts
5. **Configure OAuth providers** if needed
6. **Add hCaptcha** for spam protection

## Your Generated Secret Key

**SECRET_KEY**: `D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C`

⚠️ **Important**: Save this key securely! You'll need it for any future deployments or configuration changes.