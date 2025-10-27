# 🚀 Deploy Backend to DigitalOcean

## One-Click Deployment

Deploy the Loan Advisor Backend to DigitalOcean App Platform - starting at just **$5/month**!

[![Deploy to DigitalOcean](backend/.do/deploy-button.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/somkheartk/loan-advisor/tree/main)

## What You Get

- ✅ Fully managed Node.js backend
- ✅ Automatic HTTPS/SSL
- ✅ Auto-deploy on git push
- ✅ Built-in monitoring and logs
- ✅ Health checks and auto-restart
- ✅ Environment variable management

## Pricing Options

### Option 1: $5/month (Recommended for getting started)
- **Backend**: $5/month (Basic tier - 512MB RAM)
- **Database**: FREE (Use MongoDB Atlas Free Tier M0)
- **Total**: **$5/month**

### Option 2: $20/month (Fully managed)
- **Backend**: $5/month (Basic tier - 512MB RAM)
- **Database**: $15/month (DigitalOcean Managed MongoDB - 1GB RAM)
- **Total**: **$20/month**

## Quick Start

1. **Click the "Deploy to DigitalOcean" button above**
2. **Connect your GitHub account** (if not already connected)
3. **Select the configuration**:
   - For $5/month: Use `app-with-external-db.yaml` + MongoDB Atlas
   - For $20/month: Use `app.yaml` with managed database
4. **Set environment variables**:
   - `JWT_SECRET`: Generate a secure secret
   - `MONGODB_URI`: Your MongoDB connection string (if using external DB)
5. **Click "Deploy"** and wait 5-10 minutes

## Detailed Guides

- 📖 **[English Deployment Guide](backend/.do/DEPLOYMENT_GUIDE.md)**
- 📖 **[คู่มือการ Deploy (ภาษาไทย)](backend/.do/DEPLOYMENT_GUIDE_TH.md)**

## What Gets Deployed

- **Backend API**: Complete NestJS application with authentication
- **Database**: MongoDB (managed or external)
- **Environment**: Production-ready configuration
- **Monitoring**: Built-in health checks and logging

## After Deployment

Your API will be available at:
```
https://loan-advisor-backend-xxxxx.ondigitalocean.app
```

You can:
- View logs in the DigitalOcean dashboard
- Monitor performance and resource usage
- Scale up or down as needed
- Set up custom domains
- Configure CI/CD pipelines

## Support

For issues or questions:
- Check the [Deployment Guide](backend/.do/DEPLOYMENT_GUIDE.md)
- Review [DigitalOcean App Platform Docs](https://docs.digitalocean.com/products/app-platform/)
- Create an issue in this repository

## Next Steps

After deploying your backend:
1. Test the API endpoints
2. Update your Flutter app to use the new API URL
3. Set up monitoring and alerts
4. Configure a custom domain (optional)
5. Set up automated backups

Happy deploying! 🎉
