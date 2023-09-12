import Foundation

public class CodeLoader {
    static func load() -> [String: [String]]{
        guard
            let url = Bundle.main.url(forResource: "PhoneCodes", withExtension: "plist"),
            let data = NSDictionary(contentsOf: url) else {
            fatalError("Unable to load plist-file of phone codes")
        }
        
        return data as! [String: [String]]
    }
}

public class NameLoader {
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

public class AddressLoader {
    static func load() -> [String] {
        if let url = Bundle.main.url(forResource: "addresses", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let addressData = try decoder.decode(AddressData.self, from: data)
                
                return addressData.addresses
            } catch {
                fatalError("Unable to load json-file of addresses")
            }
        }
        return []
    }
}
