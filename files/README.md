# dev.notes commands

![dev.notes banner](docs/banner.svg)

![Static Site](https://img.shields.io/badge/type-static%20site-0f172a)
![Languages](https://img.shields.io/badge/languages-EN%20%7C%20DE%20%7C%20RU-1d4ed8)
![License: MIT](https://img.shields.io/badge/license-MIT-16a34a)

Fast, multilingual command cheat sheet in a single static page.

## Preview

![App preview](docs/preview.svg)

## Roadmap

- [ ] Add command edit mode for local entries
- [ ] Import/export custom commands as JSON
- [ ] Keyboard navigation for command cards
- [ ] Optional compact card layout for small screens
- [ ] Category analytics (count and quick stats)

## Languages

- [English](#english)
- [Deutsch](#deutsch)
- [Русский](#русский)

---

## English

### Overview

Lightweight static web app with searchable command snippets for daily developer/server tasks.

### Features

- 3 built-in languages: English, German, Russian
- Category filters
- Full-text search with highlighted matches
- One-click copy to clipboard
- Add personal commands in browser local storage
- Delete custom local commands

### Project Structure

- `index.html` - UI, styles, and app logic
- `commands_EN.json` - English command set
- `commands_DE.json` - German command set
- `commands_RU.json` - Russian command set

### Run Locally

No build step required.

Option 1:

- Open `index.html` directly in your browser

Option 2 (recommended):

```bash
python3 -m http.server 8080
```

Open: `http://localhost:8080`

### JSON Format

```json
{
  "id": 1,
  "cat": "git",
  "name": "basic push",
  "cmd": "git add .\ngit commit -m \"feat: message\"\ngit push origin main",
  "desc": "Short description",
  "params": [["flag", "meaning"]]
}
```

---

## Deutsch

### Ubersicht

Leichte statische Web-App mit durchsuchbaren Befehls-Snippets fur typische Entwickler- und Serveraufgaben.

### Funktionen

- 3 integrierte Sprachen: Englisch, Deutsch, Russisch
- Kategorien-Filter
- Volltextsuche mit Hervorhebung
- Kopieren in die Zwischenablage mit einem Klick
- Eigene Befehle im Browser (localStorage) speichern
- Lokale benutzerdefinierte Befehle loschen

### Projektstruktur

- `index.html` - UI, Styles und App-Logik
- `commands_EN.json` - Englische Befehle
- `commands_DE.json` - Deutsche Befehle
- `commands_RU.json` - Russische Befehle

### Lokal starten

Kein Build-Schritt erforderlich.

Option 1:

- `index.html` direkt im Browser offnen

Option 2 (empfohlen):

```bash
python3 -m http.server 8080
```

Dann offnen: `http://localhost:8080`

---

## Русский

### Обзор

Легкое статическое веб-приложение с поиском по командам для ежедневных задач разработчика и сервера.

### Возможности

- 3 встроенных языка: английский, немецкий, русский
- Фильтрация по категориям
- Полнотекстовый поиск с подсветкой
- Копирование команды в буфер в один клик
- Добавление своих команд в localStorage браузера
- Удаление локальных пользовательских команд

### Структура проекта

- `index.html` - интерфейс, стили и логика приложения
- `commands_EN.json` - набор команд на английском
- `commands_DE.json` - набор команд на немецком
- `commands_RU.json` - набор команд на русском

### Локальный запуск

Сборка не требуется.

Вариант 1:

- Открыть `index.html` напрямую в браузере

Вариант 2 (рекомендуется):

```bash
python3 -m http.server 8080
```

Открыть: `http://localhost:8080`

---

## License

MIT. See `LICENSE`.
