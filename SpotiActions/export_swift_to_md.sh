#!/bin/bash

# Archivo de salida
OUTPUT="swift_files.md"
> "$OUTPUT"

# Lista para acumular nombres de archivos
FILE_LIST=()

# Recorre todos los archivos .swift en el directorio actual
for file in *.swift; do
  # Verifica que haya archivos .swift
  [ -e "$file" ] || continue

  FILE_LIST+=("$file")

  {
    echo "## $file"
    echo ""
    echo '```swift'
    cat "$file"
    echo '```'
    echo ""
    echo "---"
    echo ""
  } >> "$OUTPUT"
done

# Sección final con lista de archivos
{
  echo ""
  echo "Todos los archivos SWIFT del proyecto son los siguientes:"
  echo ""
  for name in "${FILE_LIST[@]}"; do
    echo "- $name"
  done
  echo ""
  echo "Si durante el transcurso del chat necesitas el código de alguno de ellos, recurre a esta información tanto al nombre como al contenido. Recordar que el nombre de los iconos de la barra inferior son house.fill, rectangle.stack y wrench.and.screwdriver"
} >> "$OUTPUT"

echo "Archivo generado: $OUTPUT"
