# 07 - Estado actual y pendientes

## Estado actual

El repositorio cuenta con un prototipo Flutter funcional que incluye:

- Splash screen.
- Registro de usuario.
- Verificacion por codigo.
- Inicio de sesion.
- Recuperacion de contrasena.
- Dashboard de estado del terreno.
- Tarjetas de sensores.
- Detalle de sensores.
- Mapa de riesgo con ubicacion.
- Reporte de zona.
- Camara IA simulada.
- Historial de eventos.
- Alertas.
- Perfil.
- Seguridad.
- Asistente IA simulado.

## Pendientes funcionales

- Conectar autenticacion a backend real.
- Enviar codigos por correo o SMS.
- Implementar inicio de sesion con Google y Facebook.
- Persistir sesion del usuario despues de cerrar y abrir la app.
- Registrar reportes de zona en una base de datos.
- Recibir mediciones reales desde sensores ESP32.
- Calcular riesgo con reglas o modelo real.
- Enviar notificaciones push de alertas.
- Agregar roles de usuario si se requiere administracion.

## Pendientes tecnicos

- Corregir codificacion de caracteres en archivos Dart.
- Proteger contrasenas con hashing en backend.
- Definir contrato de API.
- Definir modelo de datos para sensores, eventos, alertas y reportes.
- Agregar manejo de errores centralizado.
- Aumentar cobertura de pruebas.
- Revisar permisos nativos de ubicacion.
- Agregar manejo offline si el contexto del proyecto lo requiere.

## Propuesta de roadmap

### Fase 1: estabilizacion del prototipo

- Corregir textos con caracteres rotos.
- Revisar navegacion completa.
- Mejorar pruebas de validadores y autenticacion local.
- Documentar capturas o flujo visual final.

### Fase 2: backend y datos

- Crear API de usuarios, sensores, eventos y reportes.
- Reemplazar `shared_preferences` para credenciales por autenticacion segura.
- Agregar base de datos.
- Definir endpoints y modelos.

### Fase 3: IoT

- Programar ESP32 para captura de variables.
- Enviar datos al backend.
- Validar calibracion y frecuencia de muestreo.
- Agregar identificacion de dispositivos.

### Fase 4: inteligencia artificial

- Definir datos de entrenamiento o reglas base.
- Integrar analisis real de imagen.
- Integrar asistente con contexto del usuario y sensores.
- Validar recomendaciones con criterios tecnicos.

### Fase 5: despliegue y validacion

- Preparar builds moviles.
- Configurar backend en nube.
- Probar con usuarios.
- Ajustar alertas y umbrales.

## Riesgos del proyecto

- Lecturas incorrectas de sensores pueden producir alertas falsas.
- Falta de conectividad puede impedir sincronizacion en zonas vulnerables.
- El analisis IA requiere validacion tecnica antes de recomendar acciones.
- Los datos personales y de ubicacion requieren medidas de privacidad.

## Criterios de avance

- La app debe poder consultar datos reales.
- Los reportes deben persistir en backend.
- Las alertas deben generarse con reglas claras.
- La IA debe explicar sus recomendaciones de forma entendible.
- El usuario debe recibir mensajes accionables y no ambiguos.

