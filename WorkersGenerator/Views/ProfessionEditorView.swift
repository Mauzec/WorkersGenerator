import SwiftUI

struct ProfessionEditorPercentageSection: View {
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

struct ProfessionEditView: View {
    @Binding var settingor: Settingor

    @Binding var isWrongUserData: [String: Bool]

    var body: some View {
        Form {
            Text(
                isWrongUserData["Profession"]! ? "Wrong parameters" : "Parameters are ready to save"
            )

            Section(header: Text("Setting Percentages")) {
                ForEach(0 ..< settingor.profession.count, id: \.self) { index in
                    ProfessionEditorPercentageSection(value: $settingor.profession.percentages[index], name: settingor.profession.professions[index])
                }
            }
            .onChange(of: settingor.profession) {
                if settingor.profession.percentages.reduce(0.0, { $0 + $1 }) != 100 {
                    isWrongUserData["Profession"] = true
                } else {
                    isWrongUserData["Profession"] = false
                }
            }
        }
    }

    init(settingor: Binding<Settingor>, isWrongUserData: Binding<[String: Bool]>) {
        _settingor = settingor
        _isWrongUserData = isWrongUserData
    }
}

struct ProfessionEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        @State var isWrongUserData = ["Phone": false, "Profession": false, "Salary": false]
        ProfessionEditView(settingor: $settingor, isWrongUserData: $isWrongUserData)
    }
}
