# 🔄 SwitchContextMenu

Ein simples Batch-Script zur schnellen Umschaltung zwischen dem klassischen und dem modernen Kontextmenü (Rechtsklickmenü) unter Windows 11.

---

## 🧠 Hintergrund

Windows 11 verwendet standardmäßig ein modernisiertes Kontextmenü mit reduzierter Funktionalität und einem zusätzlichen Klick auf "Weitere Optionen anzeigen". Dieses Script erlaubt es, per Mausklick zwischen dem klassischen (Windows 10-ähnlichen) und dem neuen Menü zu wechseln.

---

## ⚙️ Funktionsweise

Das Script nutzt den Windows-Registry-Pfad:

HKEY_CURRENT_USER\Software\Classes\CLSID\


und verändert den Schlüssel `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`.

---

## 🚀 Anwendung

1. Script mit Administratorrechten starten (`Rechtsklick > Als Administrator ausführen`).
2. Die Eingabeaufforderung zeigt an, welcher Modus aktiviert wird.
3. Der Windows-Explorer wird automatisch neu gestartet.

---

## 📝 Registry-Dateien (Alternativ zur .bat)

- `Enable_ClassicContextMenu.reg` – Aktiviert das alte Kontextmenü
- `Enable_ModernContextMenu.reg` – Stellt das Windows-11-Standardmenü wieder her

---

## 📂 Verzeichnisstruktur

/
├── SwitchContextMenu.bat
├── Enable_ClassicContextMenu.reg
├── Enable_ModernContextMenu.reg
└── README.md


---

## ⚠️ Hinweis

Ein Neustart des Explorers ist notwendig, um Änderungen sofort sichtbar zu machen. Wird automatisch durch das Script erledigt.

---

## 🧪 Kompatibilität

- ✅ Windows 11 (alle Editionen)
- ❌ Keine Wirkung unter Windows 10

---

## 🔒 Sicherheit

Dieses Script verändert ausschließlich einen bekannten CLSID-Eintrag der Benutzer-Registry und kann problemlos rückgängig gemacht werden.

---

## 📜 Enable_ClassicContextMenu.reg

```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]
@=""

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""

📜 Enable_ModernContextMenu.reg

Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]

