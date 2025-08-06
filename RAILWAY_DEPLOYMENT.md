# ClassQuiz Railway Deployment Guide

This guide will help you deploy ClassQuiz to Railway.app with all required services.

## Prerequisites

1. Railway account at [railway.app](https://railway.app)
2. Railway CLI installed: `npm install -g @railway/cli`
3. Git repository pushed to GitHub/GitLab

## Architecture Overview

ClassQuiz requires these services on Railway:
- **API Service** (FastAPI backend)
- **Frontend Service** (SvelteKit frontend) 
- **Worker Service** (Background tasks)
- **PostgreSQL Database**
- **Redis Cache**
- **Meilisearch** (Search engine)

## Step-by-Step Deployment

### 1. Create New Railway Project

```bash
railway login
railway new
```

### 2. Add Required Services

In your Railway dashboard, add these services:

#### PostgreSQL Database
- Add PostgreSQL from Railway's service catalog
- Note the connection details (automatically available as environment variables)

#### Redis
- Add Redis from Railway's service catalog
- Note the connection URL

#### Meilisearch
- Deploy as a custom service using Docker image: `getmeili/meilisearch:v0.28.0`
- Set environment variable: `MEILI_NO_ANALYTICS=true`

### 3. Deploy API Service (Backend)

Create a new service and connect your repository:

```bash
railway service create api
railway link [your-project-id] --service api
```

Set these environment variables in Railway dashboard:

```env
# Database (automatically set by Railway PostgreSQL)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Redis (automatically set by Railway Redis)  
REDIS=${{Redis.REDIS_URL}}

# Required Configuration
SECRET_KEY=your-super-secret-key-here-change-this
ROOT_ADDRESS=https://your-app-name.up.railway.app
MAX_WORKERS=1
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Meilisearch
MEILISEARCH_URL=${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700

# Email Configuration (Optional - set SKIP_EMAIL_VERIFICATION=True to disable)
SKIP_EMAIL_VERIFICATION=True
MAIL_PORT=587
MAIL_ADDRESS=your-email@example.com
MAIL_PASSWORD=your-email-password
MAIL_USERNAME=your-email@example.com
MAIL_SERVER=smtp.gmail.com

# Storage (Local storage for Railway)
STORAGE_BACKEND=local
STORAGE_PATH=/app/data

# External APIs (Optional)
# HCAPTCHA_KEY=your-hcaptcha-key
# PIXABAY_API_KEY=your-pixabay-key
# GOOGLE_CLIENT_ID=your-google-client-id
# GOOGLE_CLIENT_SECRET=your-google-client-secret
# GITHUB_CLIENT_ID=your-github-client-id
# GITHUB_CLIENT_SECRET=your-github-client-secret
```

Deploy the API:
```bash
railway up
```

### 4. Deploy Worker Service

Create another service for the background worker:

```bash
railway service create worker
railway link [your-project-id] --service worker
```

Use the same environment variables as the API service, but override the start command:
- Set `RAILWAY_RUN_COMMAND=arq classquiz.worker.WorkerSettings`

### 5. Deploy Frontend Service

Create the frontend service:

```bash
railway service create frontend
railway link [your-project-id] --service frontend
```

Set these environment variables:

```env
# API Connection
API_URL=${{api.RAILWAY_PRIVATE_DOMAIN}}
REDIS_URL=${{Redis.REDIS_URL}}

# Frontend Configuration
VITE_CAPTCHA_ENABLED=false
VITE_MAPBOX_ACCESS_TOKEN=your-mapbox-token-optional

# Build Configuration
NODE_ENV=production
```

Create a custom start command by adding this to your frontend service:
- Set `RAILWAY_RUN_COMMAND=cd frontend && npm run build && npm run run:prod`

### 6. Configure Networking

In Railway dashboard:
1. Generate a public domain for your frontend service
2. Update the `ROOT_ADDRESS` environment variable in your API service to match your frontend domain
3. Ensure all services can communicate via Railway's private networking

### 7. Database Migration

The API service will automatically run database migrations on startup via the `prestart.sh` script.

## Important Notes

### Environment Variables Priority
- Use Railway's built-in service references like `${{Postgres.DATABASE_URL}}`
- Generate a strong `SECRET_KEY` - you can use: `openssl rand -hex 32`
- Update `ROOT_ADDRESS` to match your actual Railway domain

### Storage Considerations
- Railway provides ephemeral storage - uploaded files will be lost on redeploy
- For production, consider using S3-compatible storage:
  ```env
  STORAGE_BACKEND=s3
  S3_ACCESS_KEY=your-access-key
  S3_SECRET_KEY=your-secret-key
  S3_BASE_URL=your-s3-endpoint
  ```

### Scaling
- Start with 1 replica for each service
- Monitor performance and scale as needed
- The worker service handles background tasks and can be scaled independently

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Verify `DATABASE_URL` is correctly set
   - Check PostgreSQL service is running

2. **Redis Connection Errors**
   - Verify `REDIS_URL` format includes `?decode_responses=True`
   - Example: `redis://user:pass@host:port/0?decode_responses=True`

3. **Frontend Can't Connect to API**
   - Verify `API_URL` points to the correct Railway private domain
   - Check CORS settings if needed

4. **Search Not Working**
   - Verify Meilisearch service is running
   - Check `MEILISEARCH_URL` environment variable

### Logs
Check service logs in Railway dashboard:
```bash
railway logs --service api
railway logs --service frontend
railway logs --service worker
```

## Production Checklist

- [ ] Set strong `SECRET_KEY`
- [ ] Configure proper email settings or disable email verification
- [ ] Set up external storage (S3) for file uploads
- [ ] Configure monitoring and alerts
- [ ] Set up custom domain
- [ ] Enable HTTPS (automatic with Railway)
- [ ] Configure external APIs (hCaptcha, OAuth providers)
- [ ] Set up backup strategy for PostgreSQL

## Support

For Railway-specific issues, check:
- [Railway Documentation](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)

For ClassQuiz issues:
- [ClassQuiz Documentation](https://classquiz.de/docs)
- [GitHub Issues](https://github.com/mawoka-myblock/ClassQuiz/issues)