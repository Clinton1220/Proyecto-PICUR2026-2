# 02 - Arquitectura del sistema

## Estructura general del repositorio

```text
GeoGuardian_AI/
  app_flutter/                Aplicacion movil Flutter.
  backend/                    Carpeta reservada para API y servicios.
  esp32/                      Carpeta reservada para firmware IoT.
  inteligencia_artificial/    Carpeta reservada para modelos y scripts IA.
  documentacion/              Documentos tecnicos y funcionales.
  figma/                      Recursos o enlaces de diseno.
  maqueta/                    Material de prototipo fisico.
  presentacion/               Material para exposicion.
  recursos/                   Imagenes, referencias y otros apoyos.
```

## Arquitectura propuesta

El sistema completo puede entenderse en cuatro capas:

1. Aplicacion movil: interfaz para usuarios finales, visualizacion del estado
   del terreno, mapas, historial, alertas, camara IA y gestion de cuenta.
2. Backend/API: capa futura para autenticar usuarios, almacenar mediciones,
   procesar reportes, enviar alertas y conectar la app con servicios externos.
3. Dispositivos IoT ESP32: nodos futuros de sensado para humedad, lluvia,
   inclinacion, temperatura u otras variables ambientales.
4. Inteligencia artificial: modulo futuro para analisis de imagen, estimacion
   de riesgo, recomendaciones y asistencia conversacional.

## Flujo esperado de informacion

```text
Sensores ESP32 -> Backend/API -> App Flutter -> Usuario
Reportes usuario -> App Flutter -> Backend/API -> Panel/alertas
Imagen del terreno -> Modulo IA -> Resultado de riesgo -> App Flutter
```

## Arquitectura actual implementada

Actualmente la app funciona principalmente en modo local:

- La autenticacion se guarda con `shared_preferences`.
- Los codigos de verificacion y recuperacion se generan en memoria.
- Las alertas, sensores e historial usan datos fijos de demostracion.
- El mapa usa `flutter_map`, OpenStreetMap y `geolocator`.
- El analisis de imagen y el asistente IA son simulaciones en `AiService`.

## Dependencias principales

- Flutter SDK.
- `flutter_map`: renderizado del mapa.
- `geolocator`: permisos y posicion del dispositivo.
- `latlong2`: manejo de coordenadas.
- `shared_preferences`: almacenamiento local simple.

## Consideraciones de seguridad

El prototipo guarda contrasenas en texto plano dentro de almacenamiento local.
Esto solo es aceptable para una demo. En una version real se debe usar backend,
hash seguro de contrasenas, tokens de sesion, HTTPS, control de permisos y
proteccion de datos personales.

