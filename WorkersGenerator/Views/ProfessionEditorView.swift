import SwiftUI

struct ProfessionEditorPercentageSection: View {
    @Binding var value: Double
    
    var name: String
    
    var body: some View {
        HStack {
            Slider(value: $value, in: 0...100, step: 1) {
                Text("\(name) Percentage")
            }
            Spacer()
            Text("\(Int(value))% \(name)")
        }
    }
}


struct ProfessionEditView: View {
    @Binding var settingor: Settingor
    @State private var rightPercentages: [Double]
    
    @State private var isWrong = false
    
    var body: some View {
        Form {
            Section(header: Text("Setting Percentages")) {
                if isWrong {
                    Text("Wrong ratios")
                        .background(.red)
                }
                ForEach(0..<settingor.profession.count, id: \.self) { index in
                    ProfessionEditorPercentageSection(value: $settingor.profession.percentages[index], name: settingor.profession.professions[index])
                }
            }
            .onChange(of: settingor.profession) { old, new in
                let sum = settingor.profession.sumPercentages
                if sum > 100.0 || sum < 100.0 {
                    rightPercentages = (old.sumPercentages == 100.0) ? old.percentages : rightPercentages
                    isWrong = true
                } else {
                    isWrong = false
                    rightPercentages = new.percentages
                }
            }
            .onDisappear {
                settingor.profession.percentages = rightPercentages
            }
        }
    }
    
    init(settingor: Binding<Settingor>) {
        _settingor = settingor
        rightPercentages = settingor.wrappedValue.profession.percentages
    }
}


struct ProfessionEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        ProfessionEditView(settingor: $settingor)
    }
}
