import SwiftUI

struct FullNameEditorPercentageSection: View {
    @Binding var value: Double
    
    var name: String

    var body: some View {
        HStack {
            Slider(value: $value, in: 0 ... 100, step: 1) {
                Text("\(name) Percentage")
            }
            Spacer()
            Text("\(Int(value))% \(name)")
        }
    }
}

struct FullNameEditorView: View {
    @Binding var settingor: Settingor
    @State private var russianPercentage: Double
    @State private var englishPercentage: Double

    var body: some View {
        Form {
            Section(header: Text("Setting Percentages")) {
                FullNameEditorPercentageSection(value: $russianPercentage, name: "Russian")
                FullNameEditorPercentageSection(value: $englishPercentage, name: "English")
            }
            .onChange(of: russianPercentage) { _, newValue in
                settingor.fullName.russianPercentage = newValue
                settingor.fullName.englishPercentage = 100.0 - newValue
                englishPercentage = 100.0 - newValue
            }
            .onChange(of: englishPercentage) { _, newValue in
                settingor.fullName.englishPercentage = newValue
                settingor.fullName.russianPercentage = 100.0 - newValue
                russianPercentage = 100.0 - newValue
            }
        }
    }

    init(settingor: Binding<Settingor>) {
        _settingor = settingor
        _russianPercentage = State(initialValue: settingor.wrappedValue.fullName.russianPercentage)
        _englishPercentage = State(initialValue: settingor.wrappedValue.fullName.englishPercentage)
    }
}

struct FullNameEditor_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        FullNameEditorView(settingor: $settingor)
    }
}
