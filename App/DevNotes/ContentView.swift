import SwiftUI

// MARK: - ViewModel

class CommandsViewModel: ObservableObject {
    @Published var commands: [Command] = []
    @Published var localCommands: [Command] = []
    @Published var selectedLanguage: AppLanguage = .ru
    @Published var selectedCat: String = "all"
    @Published var searchText: String = ""

    private let localKey = "dev_notes_local_v1"
    private var nextLocalId = -1

    var i18n: I18N { translations[selectedLanguage]! }

    var allCommands: [Command] { commands + localCommands }

    var categories: [String] {
        let cats = allCommands.map { $0.cat }
        let unique = CAT_ORDER.filter { cats.contains($0) }
        return unique
    }

    var filtered: [Command] {
        var result = allCommands
        if selectedCat != "all" {
            result = result.filter { $0.cat == selectedCat }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.name.lowercased().contains(q) ||
                $0.cmd.lowercased().contains(q) ||
                $0.desc.lowercased().contains(q) ||
                $0.cat.lowercased().contains(q)
            }
        }
        return result
    }

    var groupedFiltered: [(cat: String, commands: [Command])] {
        let cats = CAT_ORDER.filter { cat in filtered.contains(where: { $0.cat == cat }) }
        return cats.map { cat in
            (cat: cat, commands: filtered.filter { $0.cat == cat })
        }
    }

    init() {
        loadLocalCommands()
        loadCommands()
    }

    func loadCommands() {
        guard let url = Bundle.main.url(forResource: selectedLanguage.fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Command].self, from: data) else {
            commands = []
            return
        }
        commands = decoded
    }

    func setLanguage(_ lang: AppLanguage) {
        selectedLanguage = lang
        loadCommands()
    }

    func addCommand(name: String, cat: String, cmd: String, desc: String) {
        let newCmd = Command(
            id: nextLocalId,
            cat: cat,
            name: name,
            cmd: cmd,
            desc: desc,
            params: nil
        )
        nextLocalId -= 1
        localCommands.append(newCmd)
        saveLocalCommands()
    }

    func deleteLocal(id: Int) {
        localCommands.removeAll { $0.id == id }
        saveLocalCommands()
    }

    private func saveLocalCommands() {
        if let data = try? JSONEncoder().encode(localCommands) {
            UserDefaults.standard.set(data, forKey: localKey)
        }
    }

    private func loadLocalCommands() {
        if let data = UserDefaults.standard.data(forKey: localKey),
           let decoded = try? JSONDecoder().decode([Command].self, from: data) {
            localCommands = decoded
            nextLocalId = (decoded.map { $0.id }.min() ?? 0) - 1
        }
    }
}

// MARK: - Root Content View

struct ContentView: View {
    @StateObject private var vm = CommandsViewModel()
    @State private var showAddSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0d0d0f").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        heroSection
                        filterChips
                        commandList
                        addCommandButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .sheet(isPresented: $showAddSheet) {
                AddCommandView(vm: vm)
            }
        }
        .preferredColorScheme(.dark)
        .searchable(text: $vm.searchText, prompt: vm.i18n.searchPlaceholder)
    }

    // MARK: Hero
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vm.i18n.heroLabel)
                .font(.custom("Courier New", size: 11))
                .foregroundColor(Color(hex: "#a594ff"))
                .tracking(2)
            Text(vm.i18n.heroTitle)
                .font(.system(size: 28, weight: .black, design: .default))
                .foregroundColor(.white)
            Text(vm.i18n.heroDesc)
                .font(.custom("Courier New", size: 12))
                .foregroundColor(Color(hex: "#9592a8"))
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }

    // MARK: Filter chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                FilterChip(label: vm.i18n.all, isActive: vm.selectedCat == "all") {
                    vm.selectedCat = "all"
                }
                ForEach(vm.categories, id: \.self) { cat in
                    FilterChip(label: cat, color: CAT_COLORS[cat], isActive: vm.selectedCat == cat) {
                        vm.selectedCat = cat
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }

    // MARK: Command list
    private var commandList: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            if vm.filtered.isEmpty {
                Text("// \(vm.i18n.searchPlaceholder.replacingOccurrences(of: "...", with: "")) — нет результатов")
                    .font(.custom("Courier New", size: 12))
                    .foregroundColor(Color(hex: "#6b6880"))
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(vm.groupedFiltered, id: \.cat) { group in
                    sectionLabel(group.cat)
                    ForEach(group.commands) { cmd in
                        CommandRowView(
                            command: cmd,
                            isLocal: cmd.id < 0,
                            onDelete: { vm.deleteLocal(id: cmd.id) }
                        )
                        .padding(.bottom, 7)
                    }
                }
            }
        }
    }

    private func sectionLabel(_ cat: String) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: CAT_COLORS[cat] ?? "#94a3b8"))
                .frame(width: 2, height: 14)
            Text(cat.uppercased())
                .font(.custom("Courier New", size: 10))
                .foregroundColor(Color(hex: "#6b6880"))
                .tracking(3)
                .padding(.leading, 8)
        }
        .padding(.top, 22)
        .padding(.bottom, 10)
    }

    // MARK: Add button
    private var addCommandButton: some View {
        Button(action: { showAddSheet = true }) {
            HStack {
                Image(systemName: "plus")
                Text(vm.i18n.addLabel)
                    .font(.custom("Courier New", size: 12))
            }
            .foregroundColor(Color(hex: "#a594ff"))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.13), style: StrokeStyle(lineWidth: 1, dash: [4]))
            )
        }
        .padding(.top, 32)
    }

    // MARK: Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "#7c6af5"))
                    .frame(width: 7, height: 7)
                    .shadow(color: Color(hex: "#7c6af5"), radius: 4)
                Text("dev.notes")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.white)
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 4) {
                ForEach(AppLanguage.allCases) { lang in
                    Button(lang.displayName) { vm.setLanguage(lang) }
                        .font(.custom("Courier New", size: 10))
                        .foregroundColor(vm.selectedLanguage == lang ? Color(hex: "#a594ff") : Color(hex: "#6b6880"))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .background(
                            vm.selectedLanguage == lang
                                ? Color(hex: "#1a1a24")
                                : Color.clear
                        )
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(vm.selectedLanguage == lang ? Color(hex: "#7c6af5") : Color.white.opacity(0.07), lineWidth: 1)
                        )
                }
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Text("\(vm.filtered.count) \(vm.i18n.commandsWord)")
                .font(.custom("Courier New", size: 11))
                .foregroundColor(Color(hex: "#6b6880"))
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let label: String
    var color: String? = nil
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let c = color {
                    Circle()
                        .fill(Color(hex: c))
                        .frame(width: 6, height: 6)
                }
                Text(label)
                    .font(.custom("Courier New", size: 11))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .foregroundColor(isActive ? Color(hex: "#a594ff") : Color(hex: "#9592a8"))
            .background(isActive ? Color(hex: "#1a1a24") : Color.clear)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isActive ? Color(hex: "#7c6af5") : Color.white.opacity(0.07), lineWidth: 1)
            )
        }
    }
}

// MARK: - Color extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8)  & 0xFF) / 255
            b = Double(int         & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0
        }
        self.init(red: r, green: g, blue: b)
    }
}
