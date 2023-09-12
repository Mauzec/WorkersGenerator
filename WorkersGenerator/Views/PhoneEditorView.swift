import SwiftUI

struct PhoneEditorView: View {
    @Binding var settingor: Settingor
    @State private var isExpandedEachProvider: [Bool]
    
    var body: some View {
        Form {
            ForEach(0..<settingor.phone.countProviders, id: \.self) { index in
                Section(header: Text(settingor.phone.providers[index])) {
                    HStack {
                        Slider(value: Binding(
                            get: {
                                settingor.phone.percentages[index]
                            }, set: { newValue in
                                settingor.phone.percentages[index] = newValue
                            }
                        ),
                               in: 0...100,
                               step: 1
                        ) {
                            Text("\(settingor.phone.providers[index]) Percentages")
                        }
                        Text("\(Int(settingor.phone.percentages[index]))%")
                        Button(action: { withAnimation {
                            isExpandedEachProvider[index] = !isExpandedEachProvider[index]
                        }
                        }) {
                            Text("\(isExpandedEachProvider[index] ? "Less" : "More")")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    if isExpandedEachProvider[index] {
                        Label(
                            title: { Text("Use other regions") },
                            icon: { Image(systemName: "star") }
                        )
                        .labelStyle(.trailingIcon)
                        .font(.callout)
                        
                        HStack {
                            Slider(value: Binding(
                                get: {
                                    settingor.phone.extraPercentages[index]
                                }, set: { newValue in
                                    settingor.phone.extraPercentages[index] = newValue
                                }
                            ),
                                   in: 0...100,
                                   step: 1
                            ) {
                                Text("\(settingor.phone.providers[index]) Extra Percentages")
                            }
                            Text("\(Int(settingor.phone.extraPercentages[index])) %")
                        }
                    }
                }
            }
            .listSectionSpacing(1.4)
        }
    }
    
    init(settingor: Binding<Settingor>) {
        _settingor = settingor
        _isExpandedEachProvider = State(initialValue: [Bool](repeating: false, count: settingor.wrappedValue.phone.countProviders))
    }
}

struct PhoneEditorView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        PhoneEditorView(settingor: $settingor)
    }
}
