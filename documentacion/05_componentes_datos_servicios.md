# 05 - Componentes, datos y servicios

## Modelos

### UserProfile

Archivo: `app_flutter/lib/models/user.dart`

Representa un usuario registrado en la app.

Campos:

- `name`: nombre del usuario.
- `email`: correo electronico.
- `password`: contrasena.
- `verified`: indica si el correo fue verificado.

Incluye metodos `toMap()` y `fromMap()` para persistencia local.

### HistoryEvent

Archivo: `app_flutter/lib/models/history_event.dart`

Representa un evento historico de monitoreo.

Campos:

- `title`: estado del evento.
- `subtext`: resumen legible.
- `time`: fecha y hora.
- `humidity`: humedad medida.
- `inclination`: inclinacion medida.

## Servicios

### AuthService

Archivo: `app_flutter/lib/services/auth_service.dart`

Servicio singleton para autenticacion local.

Responsabilidades:

- Inicializar usuarios guardados en `shared_preferences`.
- Registrar usuarios.
- Generar codigos de verificacion y recuperacion.
- Verificar cuentas.
- Iniciar sesion.
- Restablecer contrasena.
- Actualizar perfil.
- Cambiar contrasena.
- Cerrar sesion.

Limitaciones actuales:

- Las contrasenas se guardan en texto plano.
- Los codigos se guardan en memoria y se pierden al reiniciar la app.
- No hay envio real de correo.
- No hay backend ni token de sesion persistente.

### AiService

Archivo: `app_flutter/lib/services/ai_service.dart`

Servicio singleton que simula respuestas de inteligencia artificial.

Funciones:

- `analyzeImage(imageUrl)`: genera un nivel de riesgo simulado.
- `assistantReply(prompt)`: responde segun palabras clave del mensaje.

Limitaciones actuales:

- No llama a un modelo real.
- No procesa imagenes reales.
- No usa datos de sensores en tiempo real.

## Utilidades

### Validadores

Archivo: `app_flutter/lib/utils/validators.dart`

Incluye validaciones de:

- Correo electronico.
- Contrasena.
- Fortaleza de contrasena.
- Campos obligatorios.
- Codigo de 6 digitos.

## Widgets reutilizables

- `InputField`: campo de entrada reutilizable.
- `RoundedButton`: boton reutilizable.
- `PasswordStrengthIndicator`: visualiza requisitos de contrasena.
- `StatusCard`: estado general del terreno.
- `SensorCard`: tarjeta de sensor.
- `RiskMeter`: barra de probabilidad de riesgo.
- `HistoryCard`: tarjeta para eventos historicos.
- `StatusDot`: leyenda visual para estados del mapa.

## Datos simulados

El prototipo usa valores fijos para sensores, historial, alertas y zonas de
riesgo. Estos datos permiten validar la experiencia de usuario antes de conectar
hardware, backend o IA real.

## Reglas de riesgo usadas en la demo

La app muestra tres estados principales:

- Seguro: condiciones normales.
- Precaucion: cambios que requieren observacion.
- Riesgo alto: condiciones que requieren atencion inmediata.

En una version productiva, estos estados deberian calcularse con reglas
definidas por especialistas, datos historicos, umbrales de sensores y modelos
de prediccion.

