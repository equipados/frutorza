# Lector de etiquetas para UniGUI Mobile

Este proyecto ejemplo para Delphi 10.4 y UniGUI Mobile permite capturar una foto de la etiqueta de un lote de plátanos y extraer los datos relevantes (lote, fecha, cooperativa, etc.) mediante un servicio de OCR como Azure Cognitive Services (Read API).

## Componentes principales

- **`uMainForm`**: formulario móvil que presenta el botón de captura y muestra el resultado.
- **`uMainModule`**: módulo principal que lee la configuración y expone el método `RecognizeLabel` para enviar la imagen al servicio de OCR.
- **`uLabelParser`**: clase auxiliar que interpreta el JSON retornado por el OCR y extrae los campos clave.
- **`uServerModule`**: configuración del servidor UniGUI.

## Configuración

1. Copia `config.ini.example` a la carpeta `files` en el servidor UniGUI y renómbralo a `config.ini`.
2. Edita los valores de `endpoint` y `subscriptionKey` con tus credenciales de Azure Cognitive Services Read API.

```
[vision]
endpoint=https://<tu-endpoint>/
subscriptionKey=<tu-clave>
```

## Flujo de funcionamiento

1. El usuario pulsa **"Capturar etiqueta"** y el componente `TUnimFileUpload` abre la cámara del móvil.
2. Tras tomar la foto, el flujo `UploadCompleted` guarda la imagen en memoria y llama a `MainModule.RecognizeLabel`.
3. El módulo envía la imagen al servicio de OCR y obtiene la respuesta en JSON.
4. `TLabelParser.ParseReadAPIResponse` analiza los textos detectados y asigna los valores al registro `TLabelInfo`.
5. El formulario muestra los datos en un `TUnimMemo`.

## Personalización

- Ajusta el parser para reconocer otros campos del etiquetado específico de tu cooperativa.
- Añade validaciones o almacenamiento en base de datos desde `TMainModule` para registrar los lotes.
- Cambia el proveedor de OCR modificando el método `RecognizeLabel`.

## Requisitos

- Delphi 10.4 con UniGUI Mobile.
- Cuenta de Azure Cognitive Services (o cualquier otro servicio de OCR con API REST).
