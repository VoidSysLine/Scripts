# 🖼️ Verknüpfungspfeile auf Desktop-Shortcuts entfernen (Shell Icons Override)

Dieses Skript entfernt die kleinen Verknüpfungspfeile auf Desktop-Symbolen, indem ein leerer Registry-Wert für das Overlay-Icon `29` gesetzt wird.

---

## ⚙️ Funktionsweise

- Erstellt Registry-Schlüssel:
  ```
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons
  ```
- Legt darin folgenden Zeichenfolgenwert an:
  ```
  "29" = ""
  ```
- Wert `29` steht für das Overlay-Icon von Verknüpfungen.
- Der leere Eintrag verhindert die Darstellung → die Pfeile verschwinden.
- `explorer.exe` wird automatisch mit Verzögerung neugestartet.

---

## ⚠️ Hinweis zur Stabilität

Ein direkter Neustart von `explorer.exe` unmittelbar nach Setzen eines leeren Overlay-Werts kann zu einem **Black Screen** führen.  
Dieses Skript nutzt daher eine **verzögerte Ausführung** zur Sicherheit.

---

## ▶️ Ausführen

1. Als Administrator ausführen:
   ```cmd
   apply.bat
   ```
2. Der Registry-Eintrag wird gesetzt und der Windows-Explorer nach kurzer Wartezeit neugestartet.

---

## ♻️ Rückgängig machen

Den Effekt kannst du rückgängig machen, indem du den Schlüssel löschst:
```cmd
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /f
```

---

## 📁 Dateien

- `apply.bat` – Setzt den Registry-Wert und startet den Explorer sicher neu

---

## 🔐 Voraussetzungen

- Lokale Administratorrechte
- Schreibzugriff auf `HKLM`

---

# 🖼️ Remove Shortcut Arrows on Desktop Icons (Shell Icons Override)

This script removes the small shortcut arrows on desktop icons by setting an empty registry value for overlay icon `29`.

---

## ⚙️ How It Works

- Creates registry key:
  ```
  HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons
  ```
- Adds string value:
  ```
  "29" = ""
  ```
- Value `29` refers to the shortcut overlay icon.
- Emptying this value disables the overlay → arrows disappear.
- `explorer.exe` is restarted after a short delay.

---

## ⚠️ Stability Warning

A direct restart of `explorer.exe` right after setting an empty overlay value can cause a **black screen**.  
This script uses a **delayed restart** for safety.

---

## ▶️ How to Run

1. Run as administrator:
   ```cmd
   apply.bat
   ```
2. The registry entry will be applied and Explorer restarted after a short wait.

---

## ♻️ Revert

To undo the change, delete the key:
```cmd
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /f
```

---

## 📁 Files

- `apply.bat` – Sets the registry entry and safely restarts Explorer

---

## 🔐 Requirements

- Local administrator rights
- Write access to `HKLM`
