# Pinguinz-Plane-Physics

**Pinguinz-Plane-Physics** ist ein FiveM-Skript, das realistischere Flugmechaniken für Flugzeuge hinzufügt. Es bietet verbesserte Steuerung, realistische Triebwerksausfälle, Vogelschläge, verschiedene Turbulenzstärken und viele weitere Features, die das Fliegen in FiveM deutlich dynamischer und herausfordernder machen.

---

## Funktionen

- **Realistische Triebwerksausfälle**: Triebwerksausfälle können zufällig auftreten und erfordern schnelles Handeln.
- **Vogelschläge**: Vögel können das Flugzeug treffen und Triebwerksprobleme oder andere Schäden verursachen.
- **Dynamische Turbulenz**: Turbulenz mit verschiedenen Intensitäten (mild, moderat, stark), die das Flugerlebnis realistischer machen.
- **Bessere Gleitmodus-Steuerung**: Ermöglicht eine bessere Gleitfähigkeit im Falle eines Triebwerksausfalls oder niedrigen Treibstoffs.
- **Fehlermodi für Landeklappen und Steuerflächen**: Fehler wie defekte Landeklappen oder Steuerflächen können während des Flugs auftreten.

---

## Installation

1. Lade das neueste Release von **Pinguinz-Plane-Physics** herunter.
2. Entpacke die Dateien in deinen **FiveM-Server-Ordner**.
3. Füge in der **server.cfg** folgendes hinzu:
   ```bash
   start Pinguinz-Plane-Physics
   ```
4. Bearbeite die **config.lua**, um die Turbulenzstärken und andere Einstellungen anzupassen.
5. Starte den Server neu.

---

## Konfiguration

Die Konfiguration befindet sich in der Datei **config.lua**. Hier kannst du folgende Optionen anpassen:

- **Turbulenzstärke**: Definiere die minimalen und maximalen Werte für verschiedene Turbulenzstufen.
- **Fehlerwahrscheinlichkeiten**: Stelle ein, wie häufig Fehler wie Triebwerksausfälle, Vogelschläge oder defekte Landeklappen auftreten.
- **Sprache**: Wähle die bevorzugte Sprache für Benachrichtigungen.

Beispiel für die **config.lua**:
```lua
config.defaultLocale = "de"  -- Deutsch als Standard

config.turbulenceSettings = {
    mild = { min = 10, max = 15 },
    moderate = { min = 2, max = 4 },
    superStrong = { min = 25, max = 30 }
}

config.failureChances = {
    landingGear = 0.05,
    aileron = 0.1,
    engineFailure = 0.05,
    engineFire = 0.1,
    birdStrike = 0.05,
    animalCollision = 0.1,
    rudderFailure = 0.1,
    betterGlide = 0.7
}
```

---

## Änderungen

**Version 1.0.2**:
- Möglichkeit zur Anpassung der Turbulenzstärken über die Konfigurationsdatei hinzugefügt.
- Sprachauswahl für Benachrichtigungen eingeführt.

**Version 1.0.1**:
- Fork von EntityPrimeDev

---

## Kontakt

Falls du auf Probleme stößt oder Vorschläge hast, kannst du [hier](https://github.com/GamingLuke1337/Plane-Physics-FiveM/pulls) eine Pull Request anlegen. Ich werde mich bemühen, auf Anfragen zeitnah zu reagieren.
