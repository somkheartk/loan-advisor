# DigitalOcean Deployment Configuration

This directory contains all the configuration files needed for one-click deployment to DigitalOcean App Platform.

## Files

### Configuration Files

- **`app.yaml`** - Full deployment configuration with DigitalOcean managed MongoDB
  - Total cost: $20/month ($5 for app + $15 for managed MongoDB)
  - Best for: Production environments with managed database
  
- **`app-with-external-db.yaml`** - Optimized configuration for external MongoDB
  - Total cost: $5/month (app only, using MongoDB Atlas Free Tier)
  - Best for: Development, testing, or cost-conscious deployments

### Documentation

- **`DEPLOYMENT_GUIDE.md`** - Complete English deployment guide
- **`DEPLOYMENT_GUIDE_TH.md`** - Complete Thai deployment guide (คู่มือภาษาไทย)

### Assets

- **`deploy-button.svg`** - Deploy button graphic for README files

## Quick Deploy

Click here to deploy: [Deploy to DigitalOcean](https://cloud.digitalocean.com/apps/new?repo=https://github.com/somkheartk/loan-advisor/tree/main)

## Configuration Details

### Service Tier: Basic ($5/month)
- **Memory**: 512MB RAM
- **vCPUs**: 1
- **Instance Count**: 1
- **Auto-scaling**: Disabled (can be enabled)

### Build Configuration
- **Source Directory**: `/backend`
- **Build Command**: `npm ci && npm run build`
- **Run Command**: `npm run start:prod`

### Environment Variables

Required:
- `JWT_SECRET` - Secret key for JWT token signing (must be set manually)
- `MONGODB_URI` - MongoDB connection string

Optional:
- `NODE_ENV` - Set to `production`
- `PORT` - Set to `3000`
- `JWT_EXPIRES_IN` - Token expiration (default: `7d`)

### Health Check

- **Path**: `/health`
- **Initial Delay**: 10 seconds
- **Period**: 10 seconds
- **Timeout**: 5 seconds

## Deployment Methods

### Method 1: One-Click Deploy (Recommended)

1. Click the deploy button
2. Select configuration file
3. Set environment variables
4. Deploy!

### Method 2: Manual Import

1. Go to [DigitalOcean Apps Dashboard](https://cloud.digitalocean.com/apps)
2. Create New App
3. Select GitHub repository
4. Import one of the configuration files from this directory

### Method 3: Using doctl CLI

```bash
# Install doctl
brew install doctl  # macOS
# or download from https://docs.digitalocean.com/reference/doctl/how-to/install/

# Authenticate
doctl auth init

# Deploy with managed MongoDB
doctl apps create --spec backend/.do/app.yaml

# Or deploy with external MongoDB
doctl apps create --spec backend/.do/app-with-external-db.yaml
```

## Database Options

### Option 1: MongoDB Atlas Free Tier (Recommended for $5/month)

**Cost**: FREE  
**Specs**: 512MB RAM, Shared vCPU, 5GB Storage

Setup:
1. Create account at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create free M0 cluster
3. Whitelist IPs (recommend 0.0.0.0/0 for simplicity)
4. Get connection string
5. Set as `MONGODB_URI` in DigitalOcean

### Option 2: DigitalOcean Managed MongoDB ($15/month)

**Cost**: $15/month  
**Specs**: 1GB RAM, Dedicated vCPU, 10GB Storage

Setup:
- Configuration automatically creates the database
- Connection string automatically injected as `MONGODB_URI`
- Fully managed backups and monitoring

### Option 3: External MongoDB

You can also use:
- Self-hosted MongoDB
- MongoDB Cloud (paid tiers)
- Any MongoDB-compatible database

## Security

All configurations include:
- ✅ HTTPS enabled by default
- ✅ Environment variables marked as secrets
- ✅ JWT tokens for authentication
- ✅ Password hashing with bcrypt
- ✅ Input validation
- ✅ CORS configured

**Important**: Always set a strong `JWT_SECRET` before deploying!

Generate one using:
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

## Monitoring

After deployment, monitor your app:
- View logs in DigitalOcean dashboard
- Check resource usage
- Set up alerts for downtime
- Monitor request rates

## Scaling

Upgrade options:
- **Professional**: $12/month (1GB RAM, 1 vCPU)
- **Professional Plus**: $24/month (2GB RAM, 2 vCPU)
- **Custom**: Configure your own specs

## Support

- [Full Deployment Guide](DEPLOYMENT_GUIDE.md)
- [Thai Guide (ไทย)](DEPLOYMENT_GUIDE_TH.md)
- [DigitalOcean Docs](https://docs.digitalocean.com/products/app-platform/)
- [GitHub Issues](https://github.com/somkheartk/loan-advisor/issues)

## Changelog

- **2025-10-27**: Initial deployment configuration created
  - Added `app.yaml` for managed MongoDB
  - Added `app-with-external-db.yaml` for external MongoDB
  - Created comprehensive deployment guides in English and Thai
