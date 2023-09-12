import SwiftUI
import Foundation
import xlsxwriter

public struct Generator {
    @Binding var settingor: Settingor
    let countPeople = 50000
    
    /// Full Name:
    /// Phone
    /// Address
    /// Prof
    /// Salary
    public var dictionaryData = Dictionary<String, Dictionary<String, String>>()
    private var indicesOfData = Set<String>()
    
    private var genAddresses = Dictionary<String, Int>()
    private var genPhones = Set<String>()
    private var genProfs = Dictionary<String, Int>()
    private var genEarns = Dictionary<String, Int>()
    
    private func load(resource: String) -> [String] {
        return NameLoader.load(resource: resource)
    }
    private mutating func generateFullNames() {
        let surnamesMale = load(resource: "surnamesMale")
        let namesMale = load(resource: "namesMale")
        let namesFemale = load(resource: "namesFemale")
        let surnamesFemale = load(resource: "surnamesFemale")
        
        dictionaryData[""] = [:]
        for _ in 0..<countPeople {
            var fullName = ""
            
            while dictionaryData[fullName] != nil {
                var surname = ""
                var name = ""
                var lastName = namesMale[Int.random(in: 0..<namesMale.count)]
                
                let isMale = Int.random(in: 0...1)
                if isMale == 1 {
                    name = namesFemale[Int.random(in: 0..<namesFemale.count)]
                    surname = surnamesFemale[Int.random(in: 0..<surnamesFemale.count)]
                    
                    let lastTwoOfLastName = lastName.dropFirst(lastName.count - 2)
                    if lastTwoOfLastName == "ий" || lastTwoOfLastName == "ей" || lastTwoOfLastName == "яй" {
                        lastName = "\(lastName.dropLast())евна"
                    } else {
                        lastName = "\(lastName)овна"
                    }
                } else {
                    name = namesMale[Int.random(in: 0..<namesMale.count)]
                    surname = surnamesMale[Int.random(in: 0..<surnamesMale.count)]
                    
                    let lastTwoOfLastName = lastName.dropFirst(lastName.count - 2)
                    if lastTwoOfLastName == "ий" || lastTwoOfLastName == "ей" || lastTwoOfLastName == "яй" {
                        lastName = "\(lastName.dropLast())евич"
                    } else {
                        lastName = "\(lastName)ович"
                    }
                }
                fullName = "\(surname) \(name) \(lastName)"
            }
            dictionaryData[fullName] = [:]
            indicesOfData.insert(fullName)
        }
        dictionaryData.removeValue(forKey: "")
    }
    
    private mutating func generateAddresses() {
        let addresses = AddressLoader.load()
        
        var count = 0
        var fullNameIndex = dictionaryData.keys.startIndex
        while count < countPeople {
            var randomNumber = Int.random(in: Int(settingor.minAddressNumber)!...Int(settingor.maxAddressNumber)!)
            var randomAddress = addresses.randomElement()!
            
            while genAddresses["\(randomAddress), \(randomNumber)"] != nil {
                randomNumber = Int.random(in: Int(settingor.minAddressNumber)!...Int(settingor.maxAddressNumber)!)
                randomAddress = addresses.randomElement()!
            }
            
            let randomCountAtSameAddress = Int.random(in: 50...60)
            genAddresses["\(randomAddress), \(randomNumber)"] = randomCountAtSameAddress
            
            for _ in 0..<randomCountAtSameAddress {
                if fullNameIndex == dictionaryData.keys.endIndex { break }
                
                dictionaryData[dictionaryData.keys[fullNameIndex]]!["Address"] = "\(randomAddress), \(randomNumber)"
                
                fullNameIndex = dictionaryData.keys.index(after: fullNameIndex)
            }
            
            count += randomCountAtSameAddress
        }
    }
    
    private mutating func generatePhones() {
        let codes = CodeLoader.load()
        
        var count = 0
        var index = 0
        var fullNameIndex = dictionaryData.keys.startIndex
        while count < countPeople {
            let countByRatio = Int(ceil(settingor.phone.percentages[index] / 100.0 * Double(countPeople)))
            let extraCount = Int(ceil(settingor.phone.extraPercentages[index] / 100.0 * Double(countByRatio)))
        
            var randomCode = "1"
            var randomLastNumbers = "2"
            genPhones.insert("+7\(randomCode)\(randomLastNumbers)")
            for _ in 0..<extraCount {
                while genPhones.contains("+7\(randomCode)\(randomLastNumbers)") {
                    randomCode = String(Int(codes["\(settingor.phone.providers[index])_"]!.randomElement()!)!)
                    randomLastNumbers = String()
                    while randomLastNumbers.count != 7 {
                        randomLastNumbers.append(String(Int.random(in: 0...9)))
                    }
                }
                genPhones.insert("+7\(randomCode)\(randomLastNumbers)")
                
                if fullNameIndex == dictionaryData.keys.endIndex { break }
                
                dictionaryData[dictionaryData.keys[fullNameIndex]]!["Phone"] = "+7\(randomCode)\(randomLastNumbers)"
                
                fullNameIndex = dictionaryData.keys.index(after: fullNameIndex)
                
                
            }
            count += extraCount
            
            randomCode = "1"
            randomLastNumbers = "2"
            for _ in 0..<(countByRatio-extraCount) {
                while genPhones.contains("+7\(randomCode)\(randomLastNumbers)") {
                    randomCode = String( Int(codes["\(settingor.phone.providers[index])"]!.randomElement()! )!)
                    randomLastNumbers = String()
                    while randomLastNumbers.count != 7 {
                        randomLastNumbers.append(String(Int.random(in: 0...9)))
                    }
                }
                genPhones.insert("+7\(randomCode)\(randomLastNumbers)")
                
                if fullNameIndex == dictionaryData.keys.endIndex { break }
                
                dictionaryData[dictionaryData.keys[fullNameIndex]]!["Phone"] = "+7\(randomCode)\(randomLastNumbers)"
                
                fullNameIndex = dictionaryData.keys.index(after: fullNameIndex)
                
            }
            count += (countByRatio - extraCount)
            
            index += 1
        }
        genPhones.remove("+712")
    }
    
    private mutating func setProfs() {
        var count = 0
        var index = 0
        var fullNameIndex = indicesOfData.randomElement()!

        while count < countPeople {
            let countByRatio = Int(ceil(settingor.profession.percentages[index] / 100.0 * Double(countPeople)))
            
            if countByRatio != 0 {
                genProfs[settingor.profession.professions[index]] = countByRatio
                
                for _ in 0..<countByRatio {
                    if fullNameIndex == "" { break }
                    
                    dictionaryData[fullNameIndex]!["Profession"] = settingor.profession.professions[index]
                    indicesOfData.remove(fullNameIndex)
                    fullNameIndex = indicesOfData.randomElement() ?? ""
                }
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
        
        for (key, value) in dictionaryData {
            let indexInEarns = settingor.profession.professions.firstIndex(of: value["Profession"]!)!
            let tmpString = String(settingor.earn[indexInEarns])
            let tmpHalf = String(Int(tmpString)! / 2)
            if let count = genEarns[tmpString], count != 0 {
                dictionaryData[key]!["Salary"] = tmpString
                genEarns[tmpString] = genEarns[tmpString]! - 1
            } else if let count = genEarns[tmpHalf], count != 0 {
                dictionaryData[key]!["Salary"] = String(tmpHalf)
                genEarns[tmpHalf] = genEarns[tmpHalf]! - 1
            } else {
                dictionaryData[key]!["Salary"] = String(settingor.earn[indexInEarns])
            }
        }
        
    }
    
    private mutating func createXLSX() ->  URL {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentDirectory.appendingPathComponent("example.xlsx").path
        
        let workbook = Workbook(name: filePath)
        let worksheet = workbook.addWorksheet()
        
        var index = 0
        for (key, value) in dictionaryData {
            worksheet.write(.string(key), [index, 0])
            worksheet.write(.string(value["Phone"]!), [index, 1])
            worksheet.write(.string(value["Address"]!), [index, 2])
            worksheet.write(.string(value["Profession"]!), [index, 3])
            worksheet.write(.string(value["Salary"]!), [index, 4])
            index += 1
        }
        
        workbook.close()
        
        return documentDirectory.appendingPathComponent("example.xlsx")
    }
    
    public mutating func generate() -> URL{
        generateFullNames()
        generateAddresses()
        generatePhones()
        setProfs()
        setSalary()
        
        return createXLSX()
    }
    
    init(settingor: Binding<Settingor>) {
        _settingor = settingor
    }
    
}
