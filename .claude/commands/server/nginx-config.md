# Nginx Configuration Generator for VersBottomLex.me

Generate a production-grade Nginx configuration with optimizations for our streaming platform.

## Environment Details
- **Domain**: `{{domain_name}}` (default: versbottomlex.me)
- **Environment**: `{{production|staging|development}}`
- **Server IP**: `{{server_ip}}`
- **SSL**: `{{enabled|disabled}}` (default: enabled)

## Application Components
- **Frontend Path**: `/home/dakota/versbottomlex.me/frontend/build/web`
- **Backend API Server**: Running on `localhost:3000`
- **WebSocket Server**: Running on `localhost:3001`
- **Media Server**: Running on `localhost:8080` (for WebRTC/streaming)

## Security Requirements
- [ ] Implement strong SSL configuration (TLS 1.2+, modern ciphers)
- [ ] Configure HTTP security headers:
  - Content-Security-Policy
  - X-XSS-Protection
  - X-Frame-Options
  - X-Content-Type-Options
  - Referrer-Policy
  - Permissions-Policy
- [ ] Enable DDoS protection
- [ ] Rate limiting for API endpoints
- [ ] Implement bot protection measures

## Performance Optimizations
- [ ] Configure efficient compression (Gzip, Brotli)
- [ ] Set up static file caching with appropriate headers
- [ ] Enable HTTP/2 support
- [ ] Configure worker processes and connections
- [ ] Optimize buffer sizes for streaming content
- [ ] Configure connection keepalive settings

## Caching Strategy
- [ ] Cache static assets (JS, CSS, images) with long TTL
- [ ] Set appropriate caching for API responses
- [ ] Configure browser caching directives
- [ ] Implement cache invalidation strategy

## Logging & Monitoring
- [ ] Configure access and error logs
- [ ] Set up log rotation
- [ ] Include monitoring endpoints

## Deliverables
1. Complete nginx.conf and site configuration file
2. Commands to verify syntax: `nginx -t`
3. Commands to apply configuration: `systemctl reload nginx`
4. SSL renewal automation (if applicable)
5. Basic nginx monitoring setup

Ensure the configuration follows Nginx best practices and is optimized for a live streaming platform.
