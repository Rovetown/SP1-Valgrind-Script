#!/bin/bash

# Überprüfen, ob der Dateiname als Parameter angegeben wurde
if [ $# -eq 0 ]; then
  echo "Bitte geben Sie den Dateinamen als Parameter an."
  exit 1
fi

# Überprüfen, ob die angegebene Datei existiert
if [ ! -f "$1" ]; then
  echo "Die angegebene Datei existiert nicht."
  exit 1
fi

# Wenn das Verzeichnis im Skript festgelegt werden soll, ändere den Wert von directoryOfFile entsprechend
# directoryOfFile="/pfad/zum/verzeichnis"
directoryOfFile=$(dirname "$1")

# Extrahieren des Dateinamens ohne das Verzeichnis
filename=$(basename "$1")

# Wenn das Verzeichnis basierend auf dem Dateinamen bzw. dem Verzeichnis, in dem das Skript ausgeführt wird, ermittelt werden soll
if [ "$directoryOfFile" = "." ]; then
  directoryOfFile=$(pwd)
fi

# Name der auszuführenden Datei
executableName=$(basename "$filename")

# Valgrind Befehl zum Testen des Programms
G_SLICE=always-malloc G_DEBUG=gc-friendly valgrind -v --tool=memcheck --leak-check=full --num-callers=40 --log-file="$directoryOfFile/valgrind.log" "$directoryOfFile/$executableName"

# Meldung anzeigen
echo "Die valgrind.log-Datei wurde im Verzeichnis: $directoryOfFile erstellt."

# Lese die Valgrind.log Datei die im Verzeichnis deiner C-Datei liegt
cat "$directoryOfFile/valgrind.log"

# OPTIONAL:
# Entferne die Log-Datei nachdem du sie gelesen hast (Inhalt immernoch in Konsole einsichtbar)
# rm "$directoryOfFile/valgrind.log"
