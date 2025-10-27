# DigitalOcean Deployment Configuration

This directory contains configuration files for deploying the Loan Advisor backend to DigitalOcean App Platform.

## Quick Deploy

Click the button below to deploy the backend to DigitalOcean:

[![Deploy to DigitalOcean](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/somkheartk/loan-advisor/tree/main)

## Available Configurations

### 1. `app.yaml` - Full Stack with Managed MongoDB
- **Cost**: $20/month ($5 app + $15 managed MongoDB)
- **Best for**: Production environments
- **Includes**: Automatic MongoDB database provisioning
- **Features**: Managed backups, monitoring, and scaling

### 2. `app-with-external-db.yaml` - App Only
- **Cost**: $5/month (app service only)
- **Best for**: Development or cost-conscious deployments
- **Database**: Use MongoDB Atlas Free Tier or your own MongoDB
- **Setup**: Configure `MONGODB_URI` environment variable

## What Gets Deployed

This configuration deploys the **backend service** only (NestJS API located in `/backend` directory).

### Backend Service Details
- **Technology**: NestJS (Node.js)
- **Port**: 3000
- **Health Check**: `/health` endpoint
- **Source**: `/backend` directory in this repository

## Environment Variables Required

You must set these environment variables in DigitalOcean App Platform:

1. **JWT_SECRET** (Required)
   - Purpose: Secret key for JWT token signing
   - Generate using: `node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"`

2. **MONGODB_URI** (Required for external DB configuration)
   - Purpose: MongoDB connection string
   - Example: `mongodb+srv://username:password@cluster.mongodb.net/loan-advisor`

Optional variables (have defaults):
- `NODE_ENV`: Set to `production`
- `PORT`: Set to `3000`
- `JWT_EXPIRES_IN`: Set to `7d`

## Deployment Steps

### Option 1: One-Click Deploy (Recommended)
1. Click the "Deploy to DigitalOcean" button above
2. Authorize GitHub access
3. Select the configuration file:
   - Choose `app.yaml` for managed MongoDB
   - Choose `app-with-external-db.yaml` for external MongoDB
4. Set required environment variables
5. Click "Deploy"

### Option 2: Manual Deployment
1. Go to [DigitalOcean Apps Dashboard](https://cloud.digitalocean.com/apps)
2. Click "Create App"
3. Select your GitHub repository
4. Import the configuration file from this directory
5. Configure environment variables
6. Deploy

## MongoDB Setup Options

### Option A: MongoDB Atlas (Free Tier)
1. Sign up at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free M0 cluster
3. Configure network access (whitelist 0.0.0.0/0 or specific IPs)
4. Create database user
5. Get connection string
6. Set as `MONGODB_URI` in DigitalOcean

### Option B: DigitalOcean Managed MongoDB
- Automatically provisioned when using `app.yaml`
- Connection string injected automatically
- $15/month for 1GB RAM, 10GB storage

## Resource Specifications

### Basic Tier ($5/month)
- 512MB RAM
- 1 vCPU
- HTTPS enabled
- Automatic SSL certificates
- Custom domains supported

### Upgrade Options
- **Professional**: $12/month (1GB RAM)
- **Professional Plus**: $24/month (2GB RAM)
- **Custom**: Configure your own specs

## Monitoring & Logs

After deployment:
- View real-time logs in DigitalOcean dashboard
- Monitor resource usage
- Set up alerts for downtime
- Track API request rates

## Security Features

✅ HTTPS enabled by default
✅ Environment variables stored as secrets
✅ JWT authentication
✅ Password hashing with bcrypt
✅ Input validation
✅ CORS configured

## Support & Documentation

- [Complete Deployment Guide](../backend/.do/DEPLOYMENT_GUIDE.md)
- [Thai Guide](../backend/.do/DEPLOYMENT_GUIDE_TH.md)
- [Backend Documentation](../backend/README.md)
- [DigitalOcean App Platform Docs](https://docs.digitalocean.com/products/app-platform/)

## Troubleshooting

### Component Not Detected
If you see "No component detected" error when deploying:
- Make sure you're deploying from the correct branch (main)
- Verify the configuration file exists in `.do/` directory at repository root
- The repository uses `.do/app.yaml` as the default configuration
- The backend service is configured with `source_dir: /backend` to target the Node.js application
- If the error persists, try importing the `.do/app-with-external-db.yaml` configuration manually

### Build Fails
- Check that Node.js version is compatible
- Verify all dependencies are listed in `backend/package.json`
- Review build logs in DigitalOcean dashboard

### Database Connection Issues
- Verify MongoDB URI is correct
- Check network access settings in MongoDB Atlas
- Ensure database user has proper permissions

## Additional Resources

For more detailed information, visit:
- [Backend Documentation](../backend/README.md)
- [API Documentation](../backend/API_GUIDE_TH.md)
- [Implementation Summary](../backend/IMPLEMENTATION_SUMMARY.md)
