import SwiftUI

struct AddCommandView: View {
    @ObservedObject var vm: CommandsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var cat = "other"
    @State private var cmd = ""
    @State private var desc = ""

    private var i18n: I18N { vm.i18n }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0d0d0f").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(i18n.addLabel.uppercased())
                            .font(.custom("Courier New", size: 11))
                            .foregroundColor(Color(hex: "#a594ff"))
                            .tracking(2)
                            .padding(.top, 24)
                            .padding(.bottom, 20)

                        Group {
                            fieldLabel(i18n.labelName)
                            TextField(i18n.namePlaceholder, text: $name)
                                .textFieldStyle(DevFieldStyle())
                                .padding(.bottom, 12)

                            fieldLabel(i18n.labelCat)
                            Picker("", selection: $cat) {
                                ForEach(CAT_ORDER, id: \.self) { c in
                                    Text(c).tag(c)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 10)
                            .background(Color(hex: "#0d0d0f"))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
                            )
                            .padding(.bottom, 12)

                            fieldLabel(i18n.labelCmd)
                            TextEditor(text: $cmd)
                                .font(.custom("Courier New", size: 12))
                                .foregroundColor(.white)
                                .frame(height: 80)
                                .padding(7)
                                .background(Color(hex: "#0d0d0f"))
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                                .padding(.bottom, 12)

                            fieldLabel(i18n.labelDesc)
                            TextField("Short description...", text: $desc)
                                .textFieldStyle(DevFieldStyle())
                                .padding(.bottom, 20)
                        }

                        Button(action: save) {
                            Text(i18n.save)
                                .font(.custom("Courier New", size: 12))
                                .tracking(1)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(name.isEmpty || cmd.isEmpty ? Color(hex: "#7c6af5").opacity(0.4) : Color(hex: "#7c6af5"))
                                .cornerRadius(5)
                        }
                        .disabled(name.isEmpty || cmd.isEmpty)

                        Text(i18n.addHint)
                            .font(.custom("Courier New", size: 10))
                            .foregroundColor(Color(hex: "#6b6880"))
                            .lineSpacing(4)
                            .padding(.top, 12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("×") { dismiss() }
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(Color(hex: "#6b6880"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.custom("Courier New", size: 10))
            .foregroundColor(Color(hex: "#6b6880"))
            .tracking(2)
            .padding(.bottom, 4)
    }

    private func save() {
        vm.addCommand(name: name, cat: cat, cmd: cmd, desc: desc)
        dismiss()
    }
}

// MARK: - Custom text field style

struct DevFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Courier New", size: 12))
            .foregroundColor(.white)
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(Color(hex: "#0d0d0f"))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
    }
}
