import SwiftUI

struct CommandRowView: View {
    let command: Command
    let isLocal: Bool
    let onDelete: () -> Void

    @State private var isExpanded = false
    @State private var copyState: [String: Bool] = [:]

    private var catColor: Color {
        Color(hex: CAT_COLORS[command.cat] ?? "#94a3b8")
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
                HStack(spacing: 11) {
                    Text(command.cat)
                        .font(.custom("Courier New", size: 9))
                        .tracking(1)
                        .textCase(.uppercase)
                        .foregroundColor(catColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(catColor.opacity(0.12))
                        .cornerRadius(3)

                    Text(command.name)
                        .font(.custom("Courier New", size: 13))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "#6b6880"))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            // Body
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Divider().background(Color.white.opacity(0.07))

                    if !command.desc.isEmpty {
                        Text(command.desc)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#9592a8"))
                            .lineSpacing(5)
                            .padding(.horizontal, 16)
                            .padding(.top, 4)
                    }

                    codeBlock(code: command.cmd)
                        .padding(.horizontal, 16)

                    if let params = command.params, !params.isEmpty {
                        VStack(spacing: 3) {
                            ForEach(Array(params.enumerated()), id: \.offset) { _, pair in
                                if pair.count >= 2 {
                                    HStack(alignment: .top, spacing: 10) {
                                        Text(pair[0])
                                            .font(.custom("Courier New", size: 11))
                                            .foregroundColor(Color(hex: "#22d3ee"))
                                            .frame(minWidth: 90, alignment: .leading)
                                        Text(pair[1])
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(hex: "#9592a8"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    if isLocal {
                        Button(action: onDelete) {
                            Text("× удалить")
                                .font(.custom("Courier New", size: 10))
                                .foregroundColor(Color(hex: "#6b6880"))
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                    }

                    Spacer(minLength: 16)
                }
            }
        }
        .background(Color(hex: "#13131a"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isExpanded ? Color(hex: "#7c6af5").opacity(0.4) : Color.white.opacity(0.07), lineWidth: 1)
        )
    }

    private func codeBlock(code: String) -> some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.custom("Courier New", size: 12))
                    .foregroundColor(Color(hex: "#e8e6f0"))
                    .lineSpacing(5)
                    .padding(.trailing, 52)
                    .padding(11)
            }
            .background(Color(hex: "#0d0d0f"))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )

            Button(action: { copy(code) }) {
                Text(copyState[code] == true ? "✓" : "скопировать")
                    .font(.custom("Courier New", size: 10))
                    .foregroundColor(copyState[code] == true ? Color(hex: "#4ade80") : Color(hex: "#9592a8"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: "#1a1a24"))
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(copyState[code] == true ? Color(hex: "#4ade80") : Color.white.opacity(0.13), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .padding(8)
        }
    }

    private func copy(_ text: String) {
        UIPasteboard.general.string = text
        copyState[text] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copyState[text] = false
        }
    }
}
