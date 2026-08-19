# GeoGuardian Backend

Este backend mínimo implementa autenticación JWT, gestión de dispositivos y recepción de telemetría.

Cómo ejecutar (local con Docker):

1. Copia .env.example a .env y actualiza SECRET_KEY si quieres.
2. Ejecuta:

```bash
docker-compose up --build
```

3. La API estará en http://localhost:8000

Endpoints útiles:
- GET /health
- POST /auth/register  (JSON: {"email":"...","password":"..."})
- POST /auth/login     (form data: username, password)
- POST /devices/       (Bearer token) crear dispositivo
- POST /telemetry/     (Bearer token) enviar lecturas

