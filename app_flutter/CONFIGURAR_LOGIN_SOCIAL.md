# Configurar login con Google y Facebook

El codigo de Flutter ya llama a Google y Facebook desde la pantalla de login. Para que funcione en un telefono/emulador real, reemplaza estos placeholders por credenciales reales de tus apps OAuth.

## Google

1. Crea un proyecto en Google Cloud Console.
2. Configura OAuth para Android con:
   - Package name: `com.example.geo_guardian`
   - SHA-1 del certificado debug/release que uses para correr la app.
3. Para iOS, crea un OAuth Client iOS y copia el `REVERSED_CLIENT_ID`.
4. Reemplaza en `ios/Runner/Info.plist`:
   - `TU_GOOGLE_REVERSED_CLIENT_ID`

Android no necesita un valor adicional en el `AndroidManifest.xml`; el paquete `google_sign_in` usa el package name y SHA-1 registrados en Google Cloud.

## Facebook

1. Crea una app en Meta for Developers.
2. Agrega el producto Facebook Login.
3. Configura Android con:
   - Package name: `com.example.geo_guardian`
   - Main activity: `com.example.geo_guardian.MainActivity`
   - Key hashes debug/release.
4. Copia el App ID y Client Token.
5. Reemplaza en `android/app/src/main/res/values/strings.xml`:
   - `TU_FACEBOOK_APP_ID`
   - `TU_FACEBOOK_CLIENT_TOKEN`
   - `fbTU_FACEBOOK_APP_ID` por `fb` seguido del App ID real.
6. Reemplaza en `ios/Runner/Info.plist`:
   - `TU_FACEBOOK_APP_ID`
   - `TU_FACEBOOK_CLIENT_TOKEN`
   - `fbTU_FACEBOOK_APP_ID` por `fb` seguido del App ID real.

## Despues de cambiar credenciales

Ejecuta:

```bash
flutter pub get
flutter clean
flutter run
```

Si pruebas iOS despues de actualizar pods:

```bash
cd ios
pod install
```
