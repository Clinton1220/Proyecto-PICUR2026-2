# Envío de códigos por correo

Los códigos de verificación de cuenta y de recuperación de contraseña se envían
por SMTP desde la propia app. Sin credenciales configuradas la app sigue
funcionando, pero en modo debug el código solo se imprime en la consola.

## 1. Obtener una contraseña de aplicación (Gmail)

La contraseña normal de Google **no funciona** para SMTP. Hay que generar una
contraseña de aplicación:

1. Activa la verificación en dos pasos en <https://myaccount.google.com/security>.
   Sin 2FA, Google no muestra la opción de contraseñas de aplicación.
2. Entra a <https://myaccount.google.com/apppasswords>.
3. Crea una contraseña con el nombre que quieras (p. ej. `GeoGuardian`).
4. Copia los 16 caracteres que te muestra. Es la única vez que los verás.

Con otro proveedor solo cambian el host y el puerto:

| Proveedor | Host                    | Puerto | SSL     |
| --------- | ----------------------- | ------ | ------- |
| Gmail     | `smtp.gmail.com`        | 587    | `false` |
| Outlook   | `smtp-mail.outlook.com` | 587    | `false` |
| Brevo     | `smtp-relay.brevo.com`  | 587    | `false` |
| SSL puro  | (el que corresponda)    | 465    | `true`  |

## 2. Crear `dart_define.json`

Copia la plantilla y rellénala con tus datos:

```powershell
Copy-Item dart_define.example.json dart_define.json
```

```json
{
  "SMTP_HOST": "smtp.gmail.com",
  "SMTP_PORT": "587",
  "SMTP_SSL": "false",
  "SMTP_USERNAME": "tu-correo@gmail.com",
  "SMTP_PASSWORD": "abcdefghijklmnop",
  "SMTP_FROM_NAME": "GeoGuardian AI"
}
```

`dart_define.json` está en `.gitignore`, así que las credenciales no se suben al
repositorio. **No pongas la contraseña de aplicación directamente en el código.**

## 3. Ejecutar la app

```powershell
flutter run -d windows --dart-define-from-file=dart_define.json
```

Para compilar una versión instalable:

```powershell
flutter build apk --dart-define-from-file=dart_define.json
flutter build windows --dart-define-from-file=dart_define.json
```

En VS Code puedes dejarlo fijo añadiendo esto a `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "GeoGuardian",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "toolArgs": ["--dart-define-from-file=dart_define.json"]
    }
  ]
}
```

## Comportamiento de los códigos

- 6 dígitos generados con `Random.secure()`.
- Vigencia de **10 minutos** (`AuthService.codeTtl`).
- Máximo **5 intentos** fallidos; al superarlos el código se invalida
  (`AuthService.maxCodeAttempts`).
- Se guardan en `SharedPreferences`, así que siguen siendo válidos aunque
  cierres y vuelvas a abrir la app.
- Un correo solo tiene un código vigente: pedir uno nuevo invalida el anterior.
- Un código de recuperación no sirve para verificar el registro, ni al revés.

## Limitaciones

- **Flutter Web no puede enviar SMTP.** El navegador no permite abrir sockets,
  así que en `-d chrome` el envío devuelve un error explicativo. Para web
  necesitarías un backend propio (la carpeta `backend/` está vacía) o una API
  HTTP de correo.
- Las credenciales viajan dentro del binario compilado. Es aceptable para un
  prototipo, pero para producción el envío debe hacerse desde un servidor.

## Si el correo no llega

- Revisa la carpeta de spam.
- Error `535 / authentication`: la contraseña de aplicación está mal copiada o
  estás usando la contraseña normal de la cuenta.
- Sin conexión o timeout: algunas redes (universidades, oficinas) bloquean el
  puerto 587 saliente. Prueba con datos móviles o con el puerto 465 y
  `SMTP_SSL: "true"`.
