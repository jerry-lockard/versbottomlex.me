#!/bin/bash
# ============================================================================
# VersBottomLex.me - SSL Certificate Setup and Auto-Renewal Script
# ============================================================================
# This script handles installation of Certbot, obtaining certificates,
# configuring Nginx for HTTPS, and setting up auto-renewal for the
# VersBottomLex.me webcam streaming platform.
#
# Usage: 
#   export PRIMARY_DOMAIN="versbottomlex.me"
#   export EMAIL="admin@versbottomlex.me"
#   sudo -E bash scripts/ssl-setup.sh
# ============================================================================

# Script directory - to determine project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

set -e  # Exit on any error
set -u  # Treat unset variables as errors

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if required environment variables are set
if [ -z "${PRIMARY_DOMAIN:-}" ]; then
  echo -e "${RED}ERROR: PRIMARY_DOMAIN environment variable is not set${NC}"
  echo -e "Please set it with: export PRIMARY_DOMAIN=\"yourdomain.com\""
  exit 1
fi

if [ -z "${EMAIL:-}" ]; then
  echo -e "${RED}ERROR: EMAIL environment variable is not set${NC}"
  echo -e "Please set it with: export EMAIL=\"admin@yourdomain.com\""
  exit 1
fi

# Domain configuration
# PRIMARY_DOMAIN is set from environment
WWW_DOMAIN="www.${PRIMARY_DOMAIN}"  # Automatically set based on PRIMARY_DOMAIN
# EMAIL is set from environment

# Nginx paths
NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
NGINX_CONF_FILE="${NGINX_AVAILABLE}/${PRIMARY_DOMAIN}"

# Log function for better output
log() {
  echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
  echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
  echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

info() {
  echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  error "This script must be run as root"
  exit 1
fi

# 1. Install Certbot and Nginx plugin
install_certbot() {
  log "Step 1: Installing Certbot and Nginx plugin"
  
  # Update package lists
  apt-get update
  
  # Install Certbot and Nginx plugin
  apt-get install -y certbot python3-certbot-nginx
  
  # Verify installation
  if command -v certbot >/dev/null 2>&1; then
    log "Certbot successfully installed: $(certbot --version)"
  else
    error "Certbot installation failed"
    exit 1
  fi
}

# 2. Configure basic Nginx for domain verification
configure_nginx_for_verification() {
  log "Step 2: Configuring Nginx for domain verification"
  
  # Check if Nginx is installed
  if ! command -v nginx >/dev/null 2>&1; then
    log "Nginx not found. Installing..."
    apt-get install -y nginx
  fi
  
  # Create basic Nginx configuration for domain verification
  cat > "${NGINX_CONF_FILE}" << EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name ${PRIMARY_DOMAIN} ${WWW_DOMAIN};
    
    root /var/www/html/${PRIMARY_DOMAIN};
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

  # Create document root directory
  mkdir -p /var/www/html/${PRIMARY_DOMAIN}
  
  # Create a simple index.html
  cat > "/var/www/html/${PRIMARY_DOMAIN}/index.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to ${PRIMARY_DOMAIN}</title>
</head>
<body>
    <h1>Welcome to ${PRIMARY_DOMAIN}</h1>
    <p>Site is under construction.</p>
</body>
</html>
EOF

  # Set proper permissions
  chown -R www-data:www-data /var/www/html/${PRIMARY_DOMAIN}
  
  # Enable the site
  if [ ! -L "${NGINX_ENABLED}/${PRIMARY_DOMAIN}" ]; then
    ln -s "${NGINX_CONF_FILE}" "${NGINX_ENABLED}/${PRIMARY_DOMAIN}"
  fi
  
  # Test Nginx configuration
  nginx -t && systemctl reload nginx
  
  log "Basic Nginx configuration completed"
}

# 3. Obtain SSL certificates using Certbot
obtain_certificates() {
  log "Step 3: Obtaining SSL certificates for ${PRIMARY_DOMAIN} and ${WWW_DOMAIN}"
  
  # Use Certbot to obtain certificates and automatically configure Nginx
  certbot --nginx \
    --non-interactive \
    --agree-tos \
    --email "${EMAIL}" \
    --domains "${PRIMARY_DOMAIN},${WWW_DOMAIN}" \
    --redirect \
    --staple-ocsp \
    --hsts \
    --uir
  
  # Verify certificates were obtained
  if [ -d "/etc/letsencrypt/live/${PRIMARY_DOMAIN}" ]; then
    log "Successfully obtained SSL certificates"
  else
    error "Failed to obtain SSL certificates"
    exit 1
  fi
}

# 4. Create a stronger Nginx HTTPS configuration
enhance_nginx_https_config() {
  log "Step 4: Enhancing Nginx HTTPS configuration with security headers"
  
  # Backup existing config
  cp "${NGINX_CONF_FILE}" "${NGINX_CONF_FILE}.bak"
  
  # Create enhanced Nginx configuration
  cat > "${NGINX_CONF_FILE}" << EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${PRIMARY_DOMAIN} ${WWW_DOMAIN};
    
    # Redirect all HTTP traffic to HTTPS
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    
    server_name ${PRIMARY_DOMAIN} ${WWW_DOMAIN};
    
    root /var/www/html/${PRIMARY_DOMAIN};
    index index.html index.htm index.php;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/${PRIMARY_DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${PRIMARY_DOMAIN}/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/${PRIMARY_DOMAIN}/chain.pem;
    
    # Improve SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    
    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Application specific configuration
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # For serving API endpoints (adjust if needed)
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    # Let's Encrypt verification
    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/html/${PRIMARY_DOMAIN};
    }
    
    # Deny access to hidden files
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
EOF

  # Test Nginx configuration
  nginx -t && systemctl reload nginx
  
  log "Enhanced HTTPS configuration completed"
}

# 5. Set up auto-renewal
setup_auto_renewal() {
  log "Step 5: Setting up certificate auto-renewal"
  
  # Certbot creates a systemd timer by default, let's verify it
  if systemctl list-timers | grep -q certbot; then
    log "Certbot renewal timer is already configured"
  else
    warn "Certbot renewal timer not found, creating a custom cron job"
    
    # Add cron job for renewal (runs twice daily as recommended by EFF)
    echo "0 3,15 * * * root certbot renew --quiet --post-hook 'systemctl reload nginx'" > /etc/cron.d/certbot-renewal
    chmod 644 /etc/cron.d/certbot-renewal
  fi
  
  # Create a renewal hook to reload Nginx after successful renewal
  mkdir -p /etc/letsencrypt/renewal-hooks/post
  
  cat > /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh << EOF
#!/bin/bash
# This script reloads Nginx after certificate renewal

systemctl reload nginx
echo "Nginx reloaded after certificate renewal at \$(date)" >> /var/log/letsencrypt/renewal-nginx.log
EOF

  chmod +x /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh
  
  # Test renewal process (dry run)
  certbot renew --dry-run
  
  log "Auto-renewal setup completed"
}

# 6. Test the SSL configuration
test_ssl_config() {
  log "Step 6: Testing SSL configuration"
  
  # Test HTTPS connectivity
  info "Testing HTTPS connectivity to ${PRIMARY_DOMAIN}..."
  if curl -s -o /dev/null -w "%{http_code}" "https://${PRIMARY_DOMAIN}" | grep -q "200"; then
    log "HTTPS connection to ${PRIMARY_DOMAIN} successful"
  else
    warn "HTTPS connection to ${PRIMARY_DOMAIN} failed or returned non-200 status"
  fi
  
  # Check certificate expiration
  info "Checking certificate expiration..."
  certbot certificates
  
  # Test renewal process without actually renewing
  info "Testing renewal process..."
  certbot renew --dry-run
  
  # Suggest online SSL test
  log "For a comprehensive SSL test, use: https://www.ssllabs.com/ssltest/analyze.html?d=${PRIMARY_DOMAIN}"

  # Print the configured domains for reference
  log "Primary domain: ${PRIMARY_DOMAIN}"
  log "www domain: ${WWW_DOMAIN}"
  log "Contact email: ${EMAIL}"
}

# Main execution flow
main() {
  log "Starting SSL certificate setup for ${PRIMARY_DOMAIN} and ${WWW_DOMAIN}"
  
  install_certbot
  configure_nginx_for_verification
  obtain_certificates
  enhance_nginx_https_config
  setup_auto_renewal
  test_ssl_config
  
  log "SSL certificate setup completed successfully!"
  log "Your website is now accessible via HTTPS: https://${PRIMARY_DOMAIN}"
  
  # Final suggestions
  info "Suggested next steps:"
  info "1. Regularly monitor certificate renewals: grep 'certbot' /var/log/syslog"
  info "2. Consider setting up a monitoring system to alert on certificate expiry"
  info "3. Run an SSL test at: https://www.ssllabs.com/ssltest/"
  info "4. Update your application to use HTTPS URLs"
  
  # Create a summary file in the logs directory
  mkdir -p "$ROOT_DIR/logs"
  SSL_SUMMARY_FILE="$ROOT_DIR/logs/ssl_setup_$(date +"%Y%m%d_%H%M%S").log"
  
  {
    echo "SSL Certificate Setup Summary for ${PRIMARY_DOMAIN}"
    echo "=================================================="
    echo "Setup Date: $(date)"
    echo ""
    echo "Domain Information:"
    echo "- Primary Domain: ${PRIMARY_DOMAIN}"
    echo "- WWW Domain: ${WWW_DOMAIN}"
    echo "- Contact Email: ${EMAIL}"
    echo ""
    echo "Certificate Location:"
    echo "- Certificate: /etc/letsencrypt/live/${PRIMARY_DOMAIN}/fullchain.pem"
    echo "- Private Key: /etc/letsencrypt/live/${PRIMARY_DOMAIN}/privkey.pem"
    echo "- Chain: /etc/letsencrypt/live/${PRIMARY_DOMAIN}/chain.pem"
    echo ""
    echo "Renewal Information:"
    echo "- Auto-renewal is configured via systemd timer or cron"
    echo "- Nginx will be automatically reloaded after renewal"
    echo ""
    echo "Next Steps:"
    echo "1. Monitor certificate health: certbot certificates"
    echo "2. Test your SSL configuration at: https://www.ssllabs.com/ssltest/"
    echo "3. Set up monitoring for certificate expiration"
    echo ""
    echo "SSL Setup completed successfully!"
  } > "$SSL_SUMMARY_FILE"
  
  log "SSL summary has been saved to: $SSL_SUMMARY_FILE"
  
  # Reminder about environment variables
  info "Note: This script used the following environment variables:"
  info "PRIMARY_DOMAIN=${PRIMARY_DOMAIN}"
  info "WWW_DOMAIN=${WWW_DOMAIN}"
  info "EMAIL=${EMAIL}"
  
  # Suggestion to update frontend configuration
  if [ -f "$ROOT_DIR/frontend/.env" ]; then
    log "Consider updating your frontend .env file to use HTTPS URLs"
  fi
}

# Run the main function
main

exit 0