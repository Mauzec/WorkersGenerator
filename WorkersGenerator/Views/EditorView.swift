import SwiftUI

struct EditorView: View {
    let items = ["Phone", "Profession", "Salary"]
    @Binding var settingor: Settingor

    @State private var isPresentingEditViews: [Bool]

    @State private var isWrongUserData = ["Phone": false, "Profession": false, "Salary": false]
    @State private var messageThatItHasWrongData = " "

    @State private var isEndGenerate: Bool = false
    @State private var urlOfXLSX: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    var body: some View {
        VStack {
            NavigationStack {
                List {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        HStack {
                            Text(items[index])
                            Spacer()
                            Button(action: {
                                isPresentingEditViews[index] = true
                            }) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $isPresentingEditViews[index]) {
                            NavigationStack {
                                if items[index] == "Phone" {
                                    PhoneEditorView(settingor: $settingor, isWrongUserData: $isWrongUserData)
                                }

                                if items[index] == "Profession" {
                                    ProfessionEditView(settingor: $settingor, isWrongUserData: $isWrongUserData)
                                }

                                if items[index] == "Salary" {
                                    EarnEditView(settingor: $settingor)
                                }

                                Text("")
                                    .toolbar {
                                        ToolbarItem(placement: .cancellationAction) {
                                        }
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("Done") {
                                                isPresentingEditViews[index] = false

                                                messageThatItHasWrongData = " "
                                                for (key, value) in isWrongUserData {
                                                    if value == true {
                                                        messageThatItHasWrongData = "Wrong data at \(key)"
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Generator")
            }
            VStack {
                Text(messageThatItHasWrongData)
                    .bold()
                    .foregroundStyle(.red)

                Button(action: {
                    if messageThatItHasWrongData.first! != "W" {
                        var generator = Generator(settingor: $settingor)
                        urlOfXLSX = generator.generate()
                        isEndGenerate = true
                    }

                }) {
                    Text("Generate")
                }
            }
        }
        .padding(.bottom)

        .sheet(isPresented: $isEndGenerate) {
            NavigationStack {
                Text("xlsx-file have written in Documents folder")
                Button(action: {
                    let activityViewController = UIActivityViewController(activityItems: [urlOfXLSX], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController
                    {
                        if let presentedViewController = rootViewController.presentedViewController {
                            presentedViewController.present(activityViewController, animated: true, completion: nil)
                        } else {
                            rootViewController.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }) {
                    Text("Open")
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isEndGenerate = false
                        }
                    }
                }
            }
        }
    }

    init(settingor: Binding<Settingor>) {
        _settingor = settingor
        _isPresentingEditViews = State(initialValue: [Bool](repeating: false, count: 5))
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        EditorView(settingor: $settingor)
    }
}
