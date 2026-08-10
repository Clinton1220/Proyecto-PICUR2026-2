# 04 - Manual de usuario

## Inicio de la aplicacion

Al abrir GeoGuardian AI aparece una pantalla inicial con el nombre del proyecto.
Luego la app dirige al usuario a la pantalla de inicio de sesion.

## Crear una cuenta

1. Pulsar `Registrate`.
2. Ingresar nombre completo, correo electronico y contrasena.
3. Revisar que la contrasena cumpla los requisitos de seguridad.
4. Pulsar `Crear cuenta`.
5. Ir a la pantalla de verificacion.
6. Usar el codigo de 6 digitos generado por la aplicacion.

Nota: en el prototipo el codigo se muestra en la consola de desarrollo, no se
envia por correo real.

## Iniciar sesion

1. Escribir correo electronico y contrasena.
2. Pulsar `Iniciar sesion`.
3. Si la cuenta no esta verificada, la app redirige a verificacion.
4. Si los datos son correctos, se abre la pantalla principal.

## Recuperar contrasena

1. Pulsar `Olvidaste tu contrasena`.
2. Ingresar el correo registrado.
3. Solicitar el codigo de recuperacion.
4. Ingresar el codigo y la nueva contrasena.
5. Confirmar el restablecimiento.

## Consultar el estado del terreno

En la pestana `Inicio` se muestra el estado general del terreno y un resumen de
sensores. Desde alli se puede abrir el detalle de sensores para revisar cada
variable con mas contexto.

## Ver el mapa de riesgo

En la pestana `Mapa` se muestra un mapa con marcadores de riesgo. La app puede
solicitar permiso de ubicacion. Si el permiso es concedido, centra el mapa en
la posicion actual y muestra zonas cercanas simuladas.

## Reportar una zona

Desde el mapa, pulsar `Reportar zona`, escribir una descripcion del problema o
condicion observada y enviar el reporte. En el estado actual, el envio se simula
localmente.

## Usar Camara IA

En la pestana `Camara IA`, el usuario puede entrar al flujo de analisis desde
`Tomar foto` o `Galeria`. El prototipo usa una imagen de referencia y genera una
respuesta simulada de IA.

## Revisar historial

En la pestana `Historial` se muestran registros simulados de eventos anteriores,
con datos de humedad e inclinacion.

## Gestionar cuenta

En `Ajustes` se puede:

- Editar el nombre del perfil.
- Cambiar la contrasena.
- Ver alertas recientes.
- Abrir el asistente IA.
- Cerrar sesion.

