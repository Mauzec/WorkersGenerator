import Foundation

public enum CodeLoader {
    static func load() -> [String: [String]] {
        guard
            let url = Bundle.main.url(forResource: "PhoneCodes", withExtension: "plist"),
            let data = NSDictionary(contentsOf: url)
        else {
            fatalError("Unable to load plist-file of phone codes")
        }

        return data as! [String: [String]]
    }
}

public enum NameLoader {
    static func load(resource: String) -> [String] {
        if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let surnameData = try decoder.decode(NameData.self, from: data)

                return surnameData
            } catch {
                fatalError("Unable to load json-file of surnames")
            }
        }
        return []
    }
}

public enum AddressLoader {
    static func load() -> [String: Set<String>] {
        var addresses = [String: Set<String>]()

        if let url = Bundle.main.url(forResource: "addresses", withExtension: "txt") {
            do {
                let data = try String(contentsOf: url, encoding: .utf8)
                let rows = data.components(separatedBy: .newlines)

                var index = 0
                while index < rows.count - 1 {
                    let numbers = Set((rows[index + 1].split(separator: ", ")).map { String($0) })
                    addresses[rows[index]] = numbers
                    index += 2
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return addresses
    }
}
