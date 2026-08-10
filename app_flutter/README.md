# GeoGuardian Flutter

Aplicacion movil prototipo para GeoGuardian AI, desarrollada con Flutter y Material 3.

## Funcionalidades principales

- Autenticacion local de prototipo.
- Dashboard con estado general de riesgo.
- Tarjetas de sensores para humedad, lluvia, inclinacion y temperatura.
- Mapa de riesgo.
- Vista de camara para analisis con IA.
- Historial de eventos y alertas.
- Pantallas de perfil, seguridad, configuracion y recuperacion de contrasena.

## Estructura

- `lib/main.dart`: punto de entrada de la aplicacion.
- `lib/pages/`: pantallas principales.
- `lib/widgets/`: componentes reutilizables.
- `lib/services/`: servicios locales del prototipo.
- `lib/models/`: modelos de datos.
- `lib/utils/`: validaciones y utilidades.

## Instalacion

```bash
flutter pub get
```

## Ejecucion

```bash
flutter run
```

## Pruebas

```bash
flutter test
```

## Notas

Este modulo funciona como prototipo de interfaz. La integracion con sensores reales, servicios backend y modelos de inteligencia artificial puede agregarse sobre la estructura existente.

