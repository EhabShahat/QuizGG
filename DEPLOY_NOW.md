# 🚀 Deploy ClassQuiz to Railway NOW!

Your Railway project is linked and ready. Follow these steps:

## Step 1: Create Services in Railway Dashboard

Go to [railway.app](https://railway.app) → Your QuizGG project and create these services:

### 1. Meilisearch Service ✅ (Already Deployed!)
I've already deployed Meilisearch for you using Railway CLI! 

If you need to create it manually:
- Click "New Service" → "GitHub Repo"
- Select: `EhabShahat/QuizGG`
- Name: `meilisearch`
- Root Directory: `meilisearch`

### 2. API Service
- Click "New Service" → "GitHub Repo"
- Select: `EhabShahat/QuizGG`
- Name: `api`
- Root Directory: `/` (leave empty)

### 3. Frontend Service  
- Click "New Service" → "GitHub Repo"
- Select: `EhabShahat/QuizGG`
- Name: `frontend`
- Root Directory: `frontend`

### 4. Worker Service
- Click "New Service" → "GitHub Repo"
- Select: `EhabShahat/QuizGG`
- Name: `worker`
- Root Directory: `/` (leave empty)
- Override Start Command: `arq classquiz.worker.WorkerSettings`

## Step 2: Set Environment Variables

### API Service Variables:
```
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

### Worker Service Variables:
Same as API service (copy all variables above)

### Frontend Service Variables:
```
API_URL=http://${{api.RAILWAY_PRIVATE_DOMAIN}}
REDIS_URL=${{Redis.REDIS_URL}}
VITE_CAPTCHA_ENABLED=false
NODE_ENV=production
```

## Step 3: Deploy Order

1. **Meilisearch** → Deploy first
2. **API** → Deploy after databases are ready
3. **Worker** → Deploy after API
4. **Frontend** → Deploy last

## Step 4: Generate Public Domain

1. Go to Frontend service
2. Settings → Networking → Generate Domain
3. Copy the domain (e.g., `frontend-production-xxxx.up.railway.app`)

## Step 5: Update ROOT_ADDRESS

1. Update `ROOT_ADDRESS` in API service to your frontend domain
2. Update `ROOT_ADDRESS` in Worker service to your frontend domain
3. Redeploy both services

## 🎉 Done!

Your ClassQuiz app should now be live at your frontend domain!

## Quick Commands (After Services Are Created)

```powershell
# Link to API service and deploy
railway service api
railway up

# Link to Frontend service and deploy  
railway service frontend
railway up

# Link to Worker service and deploy
railway service worker
railway up
```

## Your Secret Key (Save This!)
```
D683E3EA550160F6DCC84FE5CE5E13D82C0DAEDC610A7C4360C1266C426B728C
```