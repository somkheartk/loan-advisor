# DigitalOcean Deployment Guide

## One-Click Deployment

Deploy the Loan Advisor Backend to DigitalOcean App Platform with just one click!

### Prerequisites
- DigitalOcean account
- GitHub account connected to DigitalOcean

### Cost Overview

#### Option 1: With External MongoDB (Recommended - $5/month)
- **App Service**: $5/month (Basic - 512MB RAM)
- **Database**: FREE (MongoDB Atlas Free Tier M0)
- **Total**: **$5/month**

#### Option 2: With Managed MongoDB ($20/month)
- **App Service**: $5/month (Basic - 512MB RAM)
- **Managed MongoDB**: $15/month (Dev Database - 1GB RAM)
- **Total**: **$20/month**

## Deployment Steps

### Option 1: Deploy with External MongoDB (Recommended for $5/month)

1. **Set up MongoDB Atlas (Free)**
   - Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Create a free account and cluster (M0 Free Tier)
   - Create a database user
   - Whitelist DigitalOcean IP ranges (or allow all: 0.0.0.0/0)
   - Get your connection string

2. **Deploy to DigitalOcean**
   - Click the button below or visit [DigitalOcean Apps](https://cloud.digitalocean.com/apps/new)
   - Select your repository: `somkheartk/loan-advisor`
   - DigitalOcean will automatically detect the `.do/app-with-external-db.yaml` configuration
   - Or manually import the configuration file

3. **Configure Environment Variables**
   In the DigitalOcean App Platform dashboard, set:
   - `MONGODB_URI`: Your MongoDB Atlas connection string
     ```
     mongodb+srv://username:password@cluster.mongodb.net/loan-advisor
     ```
   - `JWT_SECRET`: Generate using this command:
     ```bash
     node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
     ```

4. **Deploy**
   - Click "Deploy" and wait for the deployment to complete
   - Your API will be available at: `https://loan-advisor-backend-xxxxx.ondigitalocean.app`

### Option 2: Deploy with Managed MongoDB ($20/month)

1. **Deploy to DigitalOcean**
   - Click the button below or visit [DigitalOcean Apps](https://cloud.digitalocean.com/apps/new)
   - Select your repository: `somkheartk/loan-advisor`
   - DigitalOcean will automatically detect the `.do/app.yaml` configuration
   - Or manually import the configuration file

2. **Configure Environment Variables**
   In the DigitalOcean App Platform dashboard, set:
   - `JWT_SECRET`: Generate using:
     ```bash
     node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
     ```
   - `MONGODB_URI` will be automatically set from the managed database

3. **Deploy**
   - Click "Deploy"
   - Your API will be available at: `https://loan-advisor-backend-xxxxx.ondigitalocean.app`

## Configuration Files

### `.do/app.yaml`
Full configuration with DigitalOcean managed MongoDB ($20/month total).

### `.do/app-with-external-db.yaml`
Optimized configuration for external MongoDB like MongoDB Atlas Free Tier ($5/month total).

## Post-Deployment

### Test Your API

1. **Health Check**
   ```bash
   curl https://your-app-url.ondigitalocean.app/health
   ```

2. **Register a User**
   ```bash
   curl -X POST https://your-app-url.ondigitalocean.app/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "password123",
       "name": "Test User"
     }'
   ```

3. **Login**
   ```bash
   curl -X POST https://your-app-url.ondigitalocean.app/auth/login \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "password": "password123"
     }'
   ```

### Connect Flutter App

Update your Flutter app's API base URL to point to your DigitalOcean app:

```dart
const String apiBaseUrl = 'https://your-app-url.ondigitalocean.app';
```

## Monitoring and Logs

- View logs in the DigitalOcean App Platform dashboard
- Monitor performance and resource usage
- Set up alerts for downtime or errors

## Scaling

As your app grows, you can easily upgrade:

1. **Professional tier**: $12/month (1GB RAM)
2. **Professional Plus**: $24/month (2GB RAM)
3. **Horizontal scaling**: Add more instances

## Security Checklist

- [x] JWT_SECRET is set to a strong, random value
- [x] MONGODB_URI is set as a secret (not visible in logs)
- [x] Database access is restricted to DigitalOcean IPs
- [x] HTTPS is automatically enabled
- [x] Environment variables are encrypted

## Troubleshooting

### Deployment Fails

**Issue**: Build fails during `npm ci`
- Check that `package.json` and `package-lock.json` are committed
- Verify Node.js version compatibility

**Issue**: Application crashes on startup
- Check environment variables are set correctly
- Verify MongoDB connection string is valid
- Check logs in DigitalOcean dashboard

### MongoDB Connection Issues

**Issue**: Cannot connect to MongoDB Atlas
- Verify IP whitelist includes DigitalOcean (or 0.0.0.0/0)
- Check database user credentials
- Verify connection string format

### API Not Responding

**Issue**: Health check fails
- Verify PORT is set to 3000
- Check that `/health` endpoint exists in code
- Review application logs

## Support

- [DigitalOcean App Platform Documentation](https://docs.digitalocean.com/products/app-platform/)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [NestJS Documentation](https://docs.nestjs.com/)

## Cost Optimization Tips

1. **Use MongoDB Atlas Free Tier** (M0) for development and small-scale production
2. **Start with Basic tier** ($5/month) and upgrade only when needed
3. **Enable auto-scaling** only if traffic patterns require it
4. **Monitor resource usage** to right-size your instance
5. **Use a CDN** for static assets if serving them from the API

## Next Steps

- Set up custom domain
- Configure SSL certificate
- Set up CI/CD with GitHub Actions
- Add monitoring and alerting
- Configure backup strategy for MongoDB
