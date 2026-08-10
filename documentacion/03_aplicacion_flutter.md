# 03 - Aplicacion Flutter

## Ubicacion

La aplicacion esta en:

```text
app_flutter/
```

## Punto de entrada

Archivo principal:

```text
app_flutter/lib/main.dart
```

El metodo `main()` inicializa Flutter, carga `AuthService` y arranca
`GeoGuardianApp`. La aplicacion usa Material 3, color base verde y pantalla
inicial `SplashPage`.

## Navegacion principal

Despues del splash y login, la pantalla `HomePage` organiza la navegacion con
una barra inferior:

- Inicio: `DashboardPage`.
- Mapa: `RiskMapPage`.
- Camara IA: `CameraPage`.
- Historial: `HistoryPage`.
- Ajustes: `SettingsPage`.

## Pantallas implementadas

### Splash

Archivo: `app_flutter/lib/pages/splash_page.dart`

Muestra una imagen de fondo, el nombre GeoGuardian y un indicador de carga.
Despues de 2 segundos navega al inicio de sesion.

### Login

Archivo: `app_flutter/lib/pages/login_page.dart`

Permite iniciar sesion con correo y contrasena, valida campos y redirige a
verificacion si la cuenta aun no esta verificada. Incluye botones visuales para
Google y Facebook, pero ambos estan deshabilitados como demo.

### Registro

Archivo: `app_flutter/lib/pages/register_page.dart`

Permite crear una cuenta con nombre, correo y contrasena. Muestra un indicador
de fortaleza y envia al usuario a la pantalla de verificacion.

### Verificacion de correo

Archivo: `app_flutter/lib/pages/verify_email_page.dart`

Solicita un codigo de 6 digitos. En el prototipo, el codigo se imprime en la
consola de desarrollo mediante `AuthService`.

### Recuperacion de contrasena

Archivo: `app_flutter/lib/pages/forgot_password_page.dart`

Permite solicitar un codigo de recuperacion y establecer una nueva contrasena.
El codigo tambien se imprime en consola durante la demo.

### Dashboard

Archivo: `app_flutter/lib/pages/dashboard_page.dart`

Muestra el saludo del usuario, el estado general del terreno y tarjetas de
sensores con valores de demostracion:

- Humedad del suelo: 65%.
- Lluvia acumulada: 0 mm.
- Inclinacion: 5 grados.
- Temperatura: 27 grados C.

Tambien permite acceder al detalle de sensores y a la pantalla de alertas.

### Detalle de sensores

Archivo: `app_flutter/lib/pages/sensor_detail_page.dart`

Lista el resumen de cada sensor con una descripcion breve del estado observado.

### Mapa de riesgo

Archivo: `app_flutter/lib/pages/risk_map_page.dart`

Usa la ubicacion del dispositivo y un mapa de OpenStreetMap para mostrar zonas
simuladas de riesgo:

- Seguro.
- Precaucion.
- Riesgo alto.

Tambien permite reportar una zona y reintentar la ubicacion.

### Reportar zona

Archivo: `app_flutter/lib/pages/report_zone_page.dart`

Permite escribir una descripcion de la situacion observada y simula el envio
del reporte.

### Camara IA

Archivos:

- `app_flutter/lib/pages/camera_page.dart`
- `app_flutter/lib/pages/camera_analysis_page.dart`

Muestra una imagen de referencia y una probabilidad simulada de derrumbe. La
pantalla de analisis llama a `AiService.analyzeImage()` y devuelve una
recomendacion simulada.

### Historial

Archivo: `app_flutter/lib/pages/history_page.dart`

Muestra eventos historicos simulados con estado, fecha, humedad e inclinacion.

### Ajustes

Archivo: `app_flutter/lib/pages/settings_page.dart`

Permite navegar a perfil, seguridad, alertas y asistente IA. Tambien incluye
cierre de sesion.

### Perfil

Archivo: `app_flutter/lib/pages/profile_page.dart`

Permite ver el correo del usuario conectado y actualizar el nombre.

### Seguridad

Archivo: `app_flutter/lib/pages/security_page.dart`

Permite cambiar la contrasena validando la contrasena actual y la nueva
contrasena.

### Asistente IA

Archivo: `app_flutter/lib/pages/ai_assistant_page.dart`

Permite escribir una pregunta y recibe respuestas simuladas segun palabras
clave como riesgo, derrumbe, lluvia, humedad, foto o imagen.

