import Foundation

struct GenericDecodable: Decodable {
    var value: Any?
    
    struct GenericDecodableCodingKeys: CodingKey {
        var stringValue: String
        
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            self.init(stringValue: "\(intValue)")
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: GenericDecodableCodingKeys.self) {
            self.value = decode(fromObject: container)
        } else if var array = try? decoder.unkeyedContainer() {
            self.value = decode(fromArray: &array)
        } else if let value = try? decoder.singleValueContainer() {
            if value.decodeNil() {
                self.value = nil
            } else {
                if let result = try? value.decode(Int.self) { self.value = result }
                if let result = try? value.decode(Double.self) { self.value = result }
                if let result = try? value.decode(String.self) { self.value = result }
                if let result = try? value.decode(Bool.self) { self.value = result }
            }
        }
    }
    
    func decode(fromObject container: KeyedDecodingContainer<GenericDecodableCodingKeys>) -> [String: Any] {
        var result: [String: Any] = [:]
        
        for key in container.allKeys {
            if let val = try? container.decode(Int.self, forKey: key) { result[key.stringValue] = val }
            else if let val = try? container.decode(Double.self, forKey: key) { result[key.stringValue] = val }
            else if let val = try? container.decode(String.self, forKey: key) { result[key.stringValue] = val }
            else if let val = try? container.decode(Bool.self, forKey: key) { result[key.stringValue] = val }
            else if let nestedContainer = try? container.nestedContainer(keyedBy: GenericDecodableCodingKeys.self, forKey: key) {
                result[key.stringValue] = decode(fromObject: nestedContainer)
            } else if (try? container.decodeNil(forKey: key)) == true {
                result.updateValue(Optional<Any>(nil) as Any, forKey: key.stringValue)
            }
        }
        
        return result
    }
    
    func decode(fromArray container: inout UnkeyedDecodingContainer) -> [Any] {
        var result: [Any] = []
        
        while !container.isAtEnd {
            if let value = try? container.decode(String.self) { result.append(value) }
            else if let value = try? container.decode(Int.self) { result.append(value) }
            else if let value = try? container.decode(Double.self) { result.append(value) }
            else if let value = try? container.decode(Bool.self) { result.append(value) }
            else if let nestedContainer = try? container.nestedContainer(keyedBy: GenericDecodableCodingKeys.self) { result.append(decode(fromObject: nestedContainer))
            } else if var nestedArray = try? container.nestedUnkeyedContainer() {
                result.append(decode(fromArray: &nestedArray))
            } else if (try? container.decodeNil()) == true {
                result.append(Optional<Any>(nil) as Any)
            }
        }
        
        return result
    }
}
