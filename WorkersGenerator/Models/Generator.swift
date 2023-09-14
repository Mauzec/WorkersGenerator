import Foundation
import SwiftUI
import xlsxwriter

public struct Generator {
    @Binding var settingor: Settingor
    let countPeople = 50_000

    private var genFullNames = Set<String>()
    private var genAddresses = [String: Int]()
    private var genPhones = Set<String>()
    private var genProfs = [String: Int]()
    private var genEarns = [String: Int]()

    private mutating func generateFullNames() {
        let surnamesMale = NameLoader.load(resource: "surnamesMale")
        let namesMale = NameLoader.load(resource: "namesMale")
        let namesFemale = NameLoader.load(resource: "namesFemale")
        let surnamesFemale = NameLoader.load(resource: "surnamesFemale")

        genFullNames.insert("")
        for _ in 0 ..< countPeople {
            var fullName = ""

            while genFullNames.contains(fullName) {
                var surname = ""
                var name = ""
                var lastName = namesMale[Int.random(in: 0 ..< namesMale.count)]

                let isMale = Int.random(in: 0 ... 1)
                if isMale == 1 {
                    name = namesFemale[Int.random(in: 0 ..< namesFemale.count)]
                    surname = surnamesFemale[Int.random(in: 0 ..< surnamesFemale.count)]

                    let lastTwoOfLastName = lastName.dropFirst(lastName.count - 2)
                    if lastTwoOfLastName == "ий" || lastTwoOfLastName == "ей" || lastTwoOfLastName == "яй" {
                        lastName = "\(lastName.dropLast())евна"
                    } else {
                        lastName = "\(lastName)овна"
                    }
                } else {
                    name = namesMale[Int.random(in: 0 ..< namesMale.count)]
                    surname = surnamesMale[Int.random(in: 0 ..< surnamesMale.count)]

                    let lastTwoOfLastName = lastName.dropFirst(lastName.count - 2)
                    if lastTwoOfLastName == "ий" || lastTwoOfLastName == "ей" || lastTwoOfLastName == "яй" {
                        lastName = "\(lastName.dropLast())евич"
                    } else {
                        lastName = "\(lastName)ович"
                    }
                }
                fullName = "\(surname) \(name) \(lastName)"
            }
            genFullNames.insert(fullName)
        }
        genFullNames.remove("")
    }

    private mutating func generateAddresses() {
        var addresses = AddressLoader.load()

        var count = 0

        while count < countPeople {
            let randomAddress = addresses.keys.randomElement()!
            let randomNumberAtAddress = addresses[randomAddress]!.randomElement()!
            let randomCountAtAddress = Int.random(in: 50 ... 100)

            genAddresses["\(randomAddress), \(randomNumberAtAddress)"] = randomCountAtAddress

            addresses[randomAddress]!.remove(randomNumberAtAddress)
            if addresses[randomAddress]!.isEmpty { addresses.removeValue(forKey: randomAddress) }

            count += randomCountAtAddress
        }
    }

    private mutating func generatePhones() {
        let codes = CodeLoader.load()

        var count = 0
        var index = 0

        while count < countPeople {
            let countByRatio = Int(ceil(settingor.phone.percentages[index] / 100.0 * Double(countPeople)))
            let extraCount = Int(ceil(settingor.phone.extraPercentages[index] / 100.0 * Double(countByRatio)))

            var randomCode = "1"
            var randomLastNumbers = "2"
            genPhones.insert("+7\(randomCode)\(randomLastNumbers)")

            for _ in 0 ..< extraCount {
                while genPhones.contains("+7\(randomCode)\(randomLastNumbers)") {
                    randomCode = String(Int(codes["\(settingor.phone.providers[index])_"]!.randomElement()!)!)
                    randomLastNumbers = String()

                    while randomLastNumbers.count != 7 {
                        randomLastNumbers.append(String(Int.random(in: 0 ... 9)))
                    }
                }
                genPhones.insert("+7\(randomCode)\(randomLastNumbers)")
            }
            count += extraCount

            randomCode = "1"
            randomLastNumbers = "2"

            for _ in 0 ..< (countByRatio - extraCount) {
                while genPhones.contains("+7\(randomCode)\(randomLastNumbers)") {
                    randomCode = String(Int(codes["\(settingor.phone.providers[index])"]!.randomElement()!)!)
                    randomLastNumbers = String()
                    while randomLastNumbers.count != 7 {
                        randomLastNumbers.append(String(Int.random(in: 0 ... 9)))
                    }
                }
                genPhones.insert("+7\(randomCode)\(randomLastNumbers)")
            }
            count += (countByRatio - extraCount)

            index += 1
        }
        genPhones.remove("+712")
    }

    private mutating func setProfs() {
        var count = 0
        var index = 0

        while count < countPeople {
            let countByRatio = Int(ceil(settingor.profession.percentages[index] / 100.0 * Double(countPeople)))

            if countByRatio != 0 {
                genProfs[settingor.profession.professions[index]] = countByRatio
            }

            count += countByRatio
            index += 1
        }
    }

    private mutating func setSalary() {
        var count = 0
        var index = 0

        while count < countPeople {
            if genProfs[settingor.profession.professions[index]] == nil {
                index += 1
                continue
            }

            let countByProfession = Int(genProfs[settingor.profession.professions[index]]!)
            let extraCount = Int(ceil(settingor.halfEarnByProfessionsPercentage[index] / 100.0 * Double(countByProfession)))

            if extraCount != 0 {
                let tmp = String(Int(settingor.earn[index])! / 2)
                if genEarns[tmp] == nil {
                    genEarns[tmp] = extraCount
                } else {
                    genEarns[tmp] = genEarns[tmp]! + extraCount
                }
            }
            count += extraCount

            if countByProfession != 0 {
                let tmp = settingor.earn[index]
                if genEarns[tmp] == nil {
                    genEarns[tmp] = countByProfession - extraCount
                } else {
                    genEarns[tmp] = genEarns[tmp]! + countByProfession - extraCount
                }
            }
            count += countByProfession - extraCount
            index += 1
        }
    }

    private mutating func readGeneratedAndWriteXLSX() -> URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentDirectory.appendingPathComponent("example.xlsx").path

        let workbook = Workbook(name: filePath)
        let worksheet = workbook.addWorksheet()

        var index = 0

        for fullName in genFullNames {
            worksheet.write(.string(fullName), [index, 0])

            let randomPhone = genPhones.randomElement()!
            worksheet.write(.string(randomPhone), [index, 1])
            genPhones.remove(randomPhone)

            let randomAddress = genAddresses.keys.randomElement()!
            worksheet.write(.string(randomAddress), [index, 2])
            genAddresses[randomAddress] = genAddresses[randomAddress]! - 1
            if genAddresses[randomAddress]! == 0 {
                genAddresses.removeValue(forKey: randomAddress)
            }

            let randomProfession = genProfs.keys.randomElement()!
            worksheet.write(.string(randomProfession), [index, 3])
            genProfs[randomProfession] = genProfs[randomProfession]! - 1
            if genProfs[randomProfession]! == 0 {
                genProfs.removeValue(forKey: randomProfession)
            }

            let indexInSettingorEarn = settingor.profession.professions.firstIndex(of: randomProfession)!
            let fullSalary = String(settingor.earn[indexInSettingorEarn])
            let halfSalary = String(Int(fullSalary)! / 2)
            if let fullCount = genEarns[fullSalary], fullCount != 0 {
                worksheet.write(.string(fullSalary), [index, 4])
                genEarns[fullSalary] = genEarns[fullSalary]! - 1
            } else if let halfCount = genEarns[halfSalary], halfCount != 0 {
                worksheet.write(.string(halfSalary), [index, 4])
                genEarns[halfSalary] = genEarns[halfSalary]! - 1
            }

            index += 1
        }

        workbook.close()

        return documentDirectory.appendingPathComponent("example.xlsx")
    }

    public mutating func generate() -> URL {
        generateFullNames()
        generateAddresses()
        generatePhones()
        setProfs()
        setSalary()

        return readGeneratedAndWriteXLSX()
    }

    init(settingor: Binding<Settingor>) {
        _settingor = settingor
    }
}
