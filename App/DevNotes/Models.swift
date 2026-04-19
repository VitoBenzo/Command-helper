import Foundation

// MARK: - Data Models

struct Command: Codable, Identifiable, Equatable {
    let id: Int
    let cat: String
    let name: String
    let cmd: String
    let desc: String
    let params: [[String]]?

    static func == (lhs: Command, rhs: Command) -> Bool {
        lhs.id == rhs.id
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case ru, en, de

    var id: String { rawValue }

    var displayName: String { rawValue.uppercased() }

    var fileName: String { "commands_\(rawValue.uppercased())" }
}

// MARK: - Category helpers

let CAT_ORDER = ["ffmpeg", "python", "git", "nginx", "node", "server", "other"]

let CAT_COLORS: [String: String] = [
    "ffmpeg": "#f87171",
    "python": "#60a5fa",
    "git":    "#4ade80",
    "nginx":  "#fbbf24",
    "node":   "#22d3ee",
    "server": "#a594ff",
    "other":  "#94a3b8"
]

// MARK: - i18n

struct I18N {
    let all: String
    let heroLabel: String
    let heroTitle: String
    let heroDesc: String
    let searchPlaceholder: String
    let loading: String
    let addLabel: String
    let labelName: String
    let labelCat: String
    let labelCmd: String
    let labelDesc: String
    let namePlaceholder: String
    let addHint: String
    let save: String
    let commandsWord: String
}

let translations: [AppLanguage: I18N] = [
    .ru: I18N(
        all: "все",
        heroLabel: "// личный справочник",
        heroTitle: "команды & утилиты",
        heroDesc: "Личный справочник рабочих команд.",
        searchPlaceholder: "поиск команды...",
        loading: "// загрузка...",
        addLabel: "+ добавить команду (локально)",
        labelName: "название",
        labelCat: "категория",
        labelCmd: "команда",
        labelDesc: "описание",
        namePlaceholder: "ffmpeg: видео в gif",
        addHint: "* Добавленные команды хранятся локально на устройстве.",
        save: "сохранить →",
        commandsWord: "команд"
    ),
    .en: I18N(
        all: "all",
        heroLabel: "// personal reference",
        heroTitle: "commands & utilities",
        heroDesc: "Personal command reference.",
        searchPlaceholder: "search command...",
        loading: "// loading...",
        addLabel: "+ add command (local)",
        labelName: "name",
        labelCat: "category",
        labelCmd: "command",
        labelDesc: "description",
        namePlaceholder: "ffmpeg: video to gif",
        addHint: "* Added commands are stored locally on your device.",
        save: "save →",
        commandsWord: "commands"
    ),
    .de: I18N(
        all: "alle",
        heroLabel: "// persönliche Referenz",
        heroTitle: "Befehle & Werkzeuge",
        heroDesc: "Persönliche Befehlsreferenz.",
        searchPlaceholder: "Befehl suchen...",
        loading: "// laden...",
        addLabel: "+ Befehl hinzufügen (lokal)",
        labelName: "Name",
        labelCat: "Kategorie",
        labelCmd: "Befehl",
        labelDesc: "Beschreibung",
        namePlaceholder: "ffmpeg: Video zu gif",
        addHint: "* Hinzugefügte Befehle werden lokal auf dem Gerät gespeichert.",
        save: "speichern →",
        commandsWord: "Befehle"
    )
]
