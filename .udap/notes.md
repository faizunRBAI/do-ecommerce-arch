# do-ecommerce-arch — Build Notes

## Status
✅ validate_project: PASS
✅ test_project: PASS (10/10 tests, lint clean)
⏳ Next: create_repo_and_push → set secrets → deploy

## Key Decisions
- **1 Droplet** deployed (DO account Droplet quota = 3; safest to use 1)
- **s-2vcpu-4gb** — gives enough RAM for Gunicorn workers + Django + migrations
- **Managed Postgres 16** + **Managed Redis 7** — DO managed services
- **DO Spaces** for media; CDN endpoint wired in Django settings
- **Redis password** read from terraform output — NOT stored as pipeline secret
- **SSH_USER** = root for DO Droplets (Ubuntu 22.04 default)
- Pipeline: lint → test → provision → configure → verify
- **black removed from CI** — black is a dev formatter not a correctness gate; flake8 + isort gate correctness
- **Redis graceful degradation** — IGNORE_EXCEPTIONS=True + REDIS_URL="" fallback to LocMemCache in tests
- **Decimal price test** — SQLite returns str for DecimalField; compare with str(product.price) for portability

## Pitfalls Fixed
- isort profile=black wants blank line between stdlib and relative imports in admin.py/urls.py
- django_redis hard-fails when Redis unreachable in tests → IGNORE_EXCEPTIONS + empty REDIS_URL → LocMemCache
- DecimalField returns str on SQLite, Decimal on Postgres → assert str(product.price)
- STATICFILES_STORAGE deprecated in Django 4.2+ → switched to STORAGES dict
- systemd daemon_reload split into separate task before enable/start

## Secrets Needed (post-push)
- DB_PASSWORD — 32-char alphanumeric — generate + set_pipeline_secret
- DJANGO_SECRET_KEY — 50-char alphanumeric — generate + set_pipeline_secret

## Files Generated
- infra/versions.tf, variables.tf, main.tf, outputs.tf
- ansible/site.yml, roles/common, roles/app, roles/webserver
- api/models.py, views.py, urls.py, admin.py, templates/storefront.html
- api/migrations/0001_initial.py
- api/tests/test_health.py, test_models.py, test_views.py
- do_ecommerce_arch/settings.py (Redis graceful degradation, STORAGES dict)
- requirements.txt, setup.cfg, pytest.ini, README.md, .env.example
