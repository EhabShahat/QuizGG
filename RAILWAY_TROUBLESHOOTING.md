# ClassQuiz Railway Troubleshooting Guide

## Common Deployment Issues

### 1. Database Connection Errors

**Error**: `could not connect to server: Connection refused`

**Solutions**:
- Verify PostgreSQL service is running in Railway dashboard
- Check `DATABASE_URL` environment variable is set correctly
- Ensure API service has access to PostgreSQL service
- Wait for PostgreSQL service to fully initialize (can take 1-2 minutes)

### 2. Redis Connection Issues

**Error**: `Error connecting to Redis` or `Connection refused`

**Solutions**:
- Verify Redis service is running
- Check `REDIS_URL` format includes `?decode_responses=True`
- Correct format: `redis://user:pass@host:port/0?decode_responses=True`
- Ensure both API and Frontend services can access Redis

### 3. Frontend Can't Connect to API

**Error**: `Network Error` or `API calls failing`

**Solutions**:
- Verify `API_URL` in frontend service points to correct Railway private domain
- Check API service is running and healthy
- Ensure API service is listening on port 80 (default in Dockerfile)
- Verify CORS settings if needed

### 4. Meilisearch Connection Issues

**Error**: `Search functionality not working`

**Solutions**:
- Verify Meilisearch service is running
- Check `MEILISEARCH_URL` environment variable format
- Correct format: `http://${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700`
- Ensure Meilisearch service is accessible from API service

### 5. Build Failures

**Error**: `Build failed` or `Docker build errors`

**Solutions**:
- Check Dockerfile paths are correct
- Verify all dependencies are available
- Check build logs for specific error messages
- Ensure sufficient build resources (Railway provides generous limits)

### 6. Environment Variable Issues

**Error**: `KeyError` or `Configuration missing`

**Solutions**:
- Verify all required environment variables are set
- Check variable names match exactly (case-sensitive)
- Use Railway's service references: `${{ServiceName.VARIABLE}}`
- Ensure SECRET_KEY is set and sufficiently long

### 7. File Upload Issues

**Error**: `File upload failed` or `Storage errors`

**Solutions**:
- Verify `STORAGE_BACKEND=local` is set
- Check `STORAGE_PATH=/app/data` is configured
- Note: Railway uses ephemeral storage - files are lost on redeploy
- Consider using S3 for production file storage

### 8. Worker Service Not Processing Jobs

**Error**: `Background tasks not running`

**Solutions**:
- Verify worker service is running
- Check worker service has same environment variables as API
- Ensure Redis connection is working for worker service
- Verify command override: `arq classquiz.worker.WorkerSettings`

## Debugging Commands

### Check Service Status
```bash
railway status
```

### View Service Logs
```bash
railway logs --service api
railway logs --service frontend
railway logs --service worker
```

### Connect to Database
```bash
railway connect postgres
```

### Connect to Redis
```bash
railway connect redis
```

### Check Environment Variables
```bash
railway variables
```

## Performance Issues

### Slow Response Times
- Check service resource usage in Railway dashboard
- Consider scaling services if needed
- Verify database queries are optimized
- Check Redis cache hit rates

### Memory Issues
- Monitor memory usage in Railway dashboard
- Adjust `MAX_WORKERS` if needed (start with 1)
- Consider upgrading Railway plan for more resources

### Database Performance
- Check for slow queries in PostgreSQL logs
- Ensure proper database indexes exist
- Consider connection pooling if needed

## Security Checklist

- [ ] Strong `SECRET_KEY` generated and set
- [ ] Database credentials secured (handled by Railway)
- [ ] No sensitive data in environment variables
- [ ] HTTPS enabled (automatic with Railway)
- [ ] Email verification configured or disabled appropriately
- [ ] External API keys secured

## Getting Help

### Railway Support
- [Railway Documentation](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [Railway Status Page](https://status.railway.app)

### ClassQuiz Support
- [ClassQuiz Documentation](https://classquiz.de/docs)
- [GitHub Issues](https://github.com/mawoka-myblock/ClassQuiz/issues)
- [Matrix Chat](https://matrix.to/#/#classquiz:matrix.org)

### Useful Railway Commands

```bash
# Login to Railway
railway login

# Link to existing project
railway link

# Deploy current directory
railway up

# Open service in browser
railway open

# View project in dashboard
railway dashboard

# Check service status
railway status

# View environment variables
railway variables

# Set environment variable
railway variables set KEY=value

# Remove environment variable
railway variables unset KEY
```

## Migration from Docker Compose

If you're migrating from the existing Docker Compose setup:

1. **Database**: Export your PostgreSQL data and import to Railway PostgreSQL
2. **Redis**: Redis data is typically ephemeral, no migration needed
3. **File Uploads**: Download files from local storage and re-upload or migrate to S3
4. **Environment Variables**: Map your existing variables to Railway format
5. **Domains**: Update DNS to point to your new Railway domain

## Production Recommendations

1. **Use S3 Storage**: Configure S3-compatible storage for file uploads
2. **Set up Monitoring**: Use Railway's built-in monitoring or external tools
3. **Configure Backups**: Set up automated PostgreSQL backups
4. **Custom Domain**: Configure your own domain instead of Railway subdomain
5. **Email Service**: Configure proper SMTP settings for email functionality
6. **External APIs**: Set up hCaptcha, OAuth providers, and other integrations
7. **Scaling**: Monitor usage and scale services as needed