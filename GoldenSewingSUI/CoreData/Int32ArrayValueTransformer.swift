import Dependencies
import Foundation

@objc(Int32ArrayValueTransformer)
public final class Int32ArrayValueTransformer: ValueTransformer {
    
    @Dependency(\.logger) var logger
    
    static let name = NSValueTransformerName(String(describing: Int32ArrayValueTransformer.self))
    
    static func register() {
        let transformer = Int32ArrayValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    public override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    public override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? [Int32] else {
            logger.error("Wrong data type: value must be a Data object; received \(type(of: value))")
            return nil
        }
        
        return Data(fromArray: value)
    }
    
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let valuesData = value as? Data else {
            logger.error("Wrong data type. Received \(type(of: value))")
            return nil
        }
        
        return valuesData.toArray(type: Int32.self)
    }
}
