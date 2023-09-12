import SwiftUI

struct EditorView: View {
    let items = ["Full Name", "Phone", "Address", "Profession", "Earn"]
    @Binding var settingor: Settingor
    @State private var editingSettingor = Settingor()
    
    @State private var isPresentingEditViews: [Bool]
    
    @State private var isEndGenerate: Bool = false
    @State private var urlOfXLSX: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    ForEach(0..<items.count, id: \.self) { index in
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
                                if items[index] == "Full Name" {
                                    FullNameEditorView(settingor: $editingSettingor)
                                }
                                
                                if items[index] == "Phone" {
                                    PhoneEditorView(settingor: $editingSettingor)
                                }
                                
                                if items[index] == "Address" {
                                    AddressEditView(settingor: $editingSettingor)
                                }
                                
                                if items[index] == "Profession" {
                                    ProfessionEditView(settingor: $editingSettingor)
                                }
                                
                                if items[index] == "Earn" {
                                    EarnEditView(settingor: $editingSettingor)
                                }
                                
                                Text("")
                                    .toolbar {
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Cancel") {
                                                isPresentingEditViews[index] = false
                                            }
                                        }
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("Done") {
                                                isPresentingEditViews[index] = false
                                                settingor = editingSettingor
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Generator")
            }
            
            Button(action: {
                var generator = Generator(settingor: $settingor)
                urlOfXLSX = generator.generate()
                isEndGenerate = true
                
            }) {
                Text("Generate")
            }
            .padding(.top)
            .frame(height: 1)
        
            
        }
        .padding(.bottom)
        
        .sheet(isPresented: $isEndGenerate) {
            NavigationStack {
                Text("xlsx-file have written in Documents folder")
                Button(action: {
                    let activityViewController = UIActivityViewController(activityItems: [urlOfXLSX], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
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
        _editingSettingor = State(initialValue: settingor.wrappedValue.self)
        _isPresentingEditViews = State(initialValue: [Bool](repeating: false, count: 5))
    }
    
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        EditorView(settingor: $settingor)
    }
}
