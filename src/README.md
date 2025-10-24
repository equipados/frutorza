# Lector de etiquetas para UniGUI Mobile

Este ejemplo para Delphi 10.4 y UniGUI Mobile permite capturar una foto de la etiqueta de un lote y extraer los datos relevantes (lote, fecha, cooperativa, etc.) aprovechando la API de ChatGPT para visión.

## Componentes principales

- **`uMainForm`**: formulario móvil que presenta el botón de captura y muestra el resultado.
- **`uMainModule`**: módulo principal que lee la configuración y expone el método `RecognizeLabel` para enviar la imagen a la API de ChatGPT.
- **`uLabelParser`**: clase auxiliar que interpreta el JSON retornado por ChatGPT y extrae los campos clave.
- **`uServerModule`**: configuración del servidor UniGUI.

## Configuración

1. Copia `config.ini.example` a la carpeta `files` en el servidor UniGUI y renómbralo a `config.ini`.
2. Edita los valores de `apiKey` y, opcionalmente, `model`/`baseUrl` con tus credenciales de OpenAI.

```
[openai]
apiKey=sk-...
model=gpt-4o-mini
baseUrl=https://api.openai.com/v1/chat/completions
```

> `baseUrl` es opcional; deja el valor por defecto para utilizar el endpoint oficial de OpenAI.

## Flujo de funcionamiento

1. El usuario pulsa **"Capturar etiqueta"** y el componente `TUnimFileUpload` abre la cámara del móvil.
2. Tras tomar la foto, el flujo `UploadCompleted` guarda la imagen en memoria y llama a `MainModule.RecognizeLabel`.
3. El módulo envía la imagen a la API de ChatGPT y obtiene una respuesta estructurada en JSON.
4. `TLabelParser.ParseChatGPTResponse` asigna los valores al registro `TLabelInfo`.
5. El formulario muestra los datos en un `TUnimMemo`.

## Personalización

- Ajusta el parser para reconocer otros campos del etiquetado específico de tu cooperativa.
- Añade validaciones o almacenamiento en base de datos desde `TMainModule` para registrar los lotes.
- Cambia el modelo de ChatGPT modificando los valores del `config.ini`.

## Requisitos

- Delphi 10.4 con UniGUI Mobile (probado con la versión 1.90.1552).
- Cuenta de OpenAI con acceso a modelos con capacidad de visión.
