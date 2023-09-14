import SwiftUI

struct AddressEditView: View {
    @Binding var settingor: Settingor

    @State private var rightMin: String = "1"
    @State private var rightMax: String = "400"

    @State private var isWrong: Color = .secondary

    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("min")
                            .font(.footnote)
                        Spacer()
                    }
                    TextField("min", text: $settingor.minAddressNumber)
                        .padding(10)
                        .border(Color.gray, width: 1)
                        .background(isWrong)
                }
                Spacer()
                VStack {
                    HStack {
                        Text("max")
                            .font(.footnote)
                        Spacer()
                    }
                    TextField("max", text: $settingor.maxAddressNumber)
                        .padding(10)
                        .border(Color.gray, width: 1)
                        .background(isWrong)
                }
            }
            .padding()

            .onDisappear {
                settingor.maxAddressNumber = rightMax
                settingor.minAddressNumber = rightMin
            }

            .onChange(of: settingor.minAddressNumber) { _, _ in
                if let min = Int(settingor.minAddressNumber), let max = Int(settingor.maxAddressNumber) {
                    if min > max {
                        isWrong = .red
                    } else {
                        rightMax = settingor.maxAddressNumber
                        rightMin = settingor.minAddressNumber

                        isWrong = .secondary
                    }
                }
            }
            .onChange(of: settingor.maxAddressNumber) { _, _ in
                if let min = Int(settingor.minAddressNumber), let max = Int(settingor.maxAddressNumber) {
                    if min > max {
                        isWrong = .red
                    } else {
                        rightMax = settingor.maxAddressNumber
                        rightMin = settingor.minAddressNumber

                        isWrong = .secondary
                    }
                }
            }

            Spacer()
        }
    }
}

struct AddressEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var settingor = Settingor.sampleSettingor
        AddressEditView(settingor: $settingor)
    }
}
