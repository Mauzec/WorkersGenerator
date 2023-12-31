import Foundation
import xlsxwriter

public struct FullNameSettings {
    var russianPercentage: Double = 100
    var englishPercentage: Double = 0

    var totalPercentage: Double { russianPercentage + englishPercentage }
}

public struct PhoneSettings {
    var providers: [String]
    var percentages: [Double]
    var extraPercentages: [Double]

    var countProviders: Int {
        if providers.count != percentages.count { fatalError("counts of providers and percentages not the same") }
        else { return providers.count }
    }

    private func loadPlistArray() -> ([String], [Double]) {
        guard
            let url = Bundle.main.url(forResource: "PhoneProviders", withExtension: "plist"),
            let data = NSDictionary(contentsOf: url)
        else {
            fatalError("Unable to access property list Phones.plist")
        }

        var providers = [String]()
        var percentages = [Double]()

        data.forEach { key, value in
            providers.append(key as! String)
            percentages.append(value as! Double)
        }

        return (providers, percentages)
    }

    init() {
        providers = []
        percentages = []
        extraPercentages = []

        (providers, percentages) = loadPlistArray()
        extraPercentages = [Double](repeating: 0, count: countProviders)
    }
}

public struct ProfessionSettings {
    var professions: [String]
    var percentages: [Double]

    var sumPercentages: Double {
        return percentages.reduce(0.0) { $0 + $1 }
    }

    var count: Int { professions.count }

    private func loadPlistArray() -> [String] {
        guard
            let url = Bundle.main.url(forResource: "Professions", withExtension: "plist"),
            let data = NSArray(contentsOf: url)
        else {
            fatalError("Unable to access property list Phones.plist")
        }

        return data as! [String]
    }

    init() {
        professions = []
        percentages = []

        professions = loadPlistArray()
        percentages = [Double](repeating: 0, count: count)
        percentages[0] = 50.0
        percentages[1] = 1.0
        percentages[2] = 9.0
        percentages[3] = 40.0
    }
}

struct Settingor {
    var phone = PhoneSettings()
    var profession = ProfessionSettings()
    var earn: [String]
    var halfEarnByProfessionsPercentage: [Double]

    init() {
        earn = [String](repeating: "25000", count: profession.count)
        halfEarnByProfessionsPercentage = [Double](repeating: 0.0, count: profession.count)

        earn[0] = "125000"
        earn[1] = "550000"
        earn[2] = "90000"
        earn[3] = "100000"

        halfEarnByProfessionsPercentage[0] = 50.0
        halfEarnByProfessionsPercentage[1] = 10.0
        halfEarnByProfessionsPercentage[2] = 30.0
        halfEarnByProfessionsPercentage[3] = 20.0
    }
}

extension Settingor {
    static var sampleSettingor: Settingor {
        var settings = Settingor()

        return settings
    }
}

extension ProfessionSettings: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        for index in 0 ..< lhs.count {
            if lhs.percentages[index] != rhs.percentages[index] {
                return false
            }
        }
        return true
    }
}
