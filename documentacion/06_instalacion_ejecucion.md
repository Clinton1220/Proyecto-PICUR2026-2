# 06 - Instalacion y ejecucion

## Requisitos

- Flutter SDK instalado.
- Dart incluido con Flutter.
- Android Studio, Visual Studio Code u otro editor compatible.
- Emulador Android, dispositivo fisico o entorno de escritorio compatible.
- Conexion a internet para cargar imagenes remotas y mapas de OpenStreetMap.

## Instalar dependencias

Desde la raiz del repositorio:

```bash
cd app_flutter
flutter pub get
```

## Ejecutar la aplicacion

```bash
flutter run
```

Flutter mostrara los dispositivos disponibles y permitira seleccionar uno.

## Ejecutar pruebas

```bash
cd app_flutter
flutter test
```

Actualmente existe una prueba basica que valida que la pantalla de login cargue
y muestre textos esperados.

## Permisos de ubicacion

La pantalla de mapa requiere permisos de ubicacion. En Android e iOS puede ser
necesario revisar los manifiestos y configuraciones nativas antes de publicar.

## Recomendaciones de desarrollo

- Usar `flutter analyze` antes de entregar cambios.
- Usar `flutter test` para validar pruebas.
- Mantener las credenciales fuera del repositorio.
- Sustituir datos simulados por servicios reales de forma incremental.
- Probar el mapa en dispositivo real para validar permisos y GPS.

## Problemas conocidos

- Varias cadenas de texto muestran caracteres mal codificados, por ejemplo
  `contraseÃ±a` en lugar de `contrasena` o `contraseña`.
- El login social es visual solamente.
- La IA y los sensores son simulados.
- No existe backend productivo conectado.

