# DO Ecommerce Arch

Production-grade Python e-commerce platform deployed on DigitalOcean.

## Stack

| Layer | Technology |
|---|---|
| **Runtime** | Python 3.11 / Django 4.2 |
| **WSGI** | Gunicorn (unix socket) |
| **Reverse Proxy** | NGINX |
| **Database** | Managed PostgreSQL 16 (DigitalOcean) |
| **Cache / Sessions** | Managed Redis 7 (DigitalOcean) |
| **Media Storage** | DO Spaces + CDN |
| **IaC** | Terraform (DigitalOcean provider) |
| **Config Mgmt** | Ansible |
| **CI/CD** | GitHub Actions |

## Architecture

```
Users ──HTTPS──► DO Load Balancer ──HTTP──► Cloud Firewall
                                                    │
                                         ┌──────────┘ VPC
                                         ▼
                                   Droplet (NGINX + Gunicorn + Django)
                                     │           │           │
                               Managed PG   Managed Redis  DO Spaces CDN
```

## Local Development

```bash
cp .env.example .env          # fill in DATABASE_URL etc.
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Visit http://localhost:8000

## Running Tests

```bash
pip install -r requirements.txt
python -m pytest api/tests/ -v
```

## Deployment

Deployment is fully automated via GitHub Actions on push to `main`:

1. **lint** — flake8 + black + isort
2. **test** — pytest against SQLite
3. **provision** — Terraform provisions Droplet, LB, Managed PG, Managed Redis, DO Spaces
4. **configure** — Ansible configures the Droplet (venv, app, systemd, NGINX)
5. **verify** — health check `GET /health/` with retries

## Endpoints

| Endpoint | Description |
|---|---|
| `GET /` | Storefront (product catalogue) |
| `GET /health/` | Health check (used by LB + CI verify) |
| `GET /api/products/` | JSON product list |
| `GET /api/info/` | Runtime info |
| `GET /admin/` | Django Admin |

## Infrastructure Cost (est.)

| Resource | Monthly |
|---|---|
| Droplet s-2vcpu-4gb | ~$24 |
| Managed PostgreSQL basic-1 | ~$15 |
| Managed Redis | ~$15 |
| DO Load Balancer | ~$12 |
| DO Spaces + CDN | ~$5+ |
| **Total** | **~$71–95/mo** |

## Optional Enhancements

- Scale to 3 Droplets behind the LB (requires DO quota increase)
- Add Let's Encrypt TLS cert to the LB for HTTPS termination
- Add Managed PostgreSQL read replica
- Add Redis AOF persistence for cart durability
- Add DO Monitoring alerts
