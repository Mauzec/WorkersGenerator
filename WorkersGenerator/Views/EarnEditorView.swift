import SwiftUI


struct EarnEditView: View {
    @Binding var settingor: Settingor
    @State private var isExpandedEachEarn: [Bool]
    
    var body: some View {
        Form {
            Section(header: Text("Salary")) {
                ForEach(0..<settingor.profession.count, id: \.self) { index in
                    HStack {
                        TextField(settingor.earn[index], text: $settingor.earn[index])
                        Spacer()
                        Text("\(settingor.profession.professions[index])")
                        Button(action: { withAnimation {
                            isExpandedEachEarn[index] = !isExpandedEachEarn[index]
                        }
                        }) {
                            Text("\(isExpandedEachEarn[index] ? "Less" : "More")")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    if isExpandedEachEarn[index] {
                        Label(
                            title: { Text("Half Salary") },
                            icon: { Image(systemName: "circle") }
                        )
                        .labelStyle(.trailingIcon)
                        .font(.callout)
                        
                        HStack {
                            Slider(value: $settingor.halfEarnByProfessionsPercentage[index], in: 0...100, step: 1) {
                                Text("Half Salary of \(settingor.profession.professions[index])")
                            }
                            Text("\(Int(settingor.halfEarnByProfessionsPercentage[index])) %")
                        }
                    }
                }
            }
        }
    }
    init(settingor: Binding<Settingor>) {
        _settingor = settingor
        isExpandedEachEarn = [Bool](repeating: false, count: settingor.profession.professions.count)
    }
}


struct EarnEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        ProfessionEditView(settingor: $settingor)
    }
}
