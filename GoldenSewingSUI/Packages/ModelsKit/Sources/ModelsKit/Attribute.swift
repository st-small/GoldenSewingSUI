import Constants
import Foundation

public struct Attribute: Decodable {
    let defaultName: String
    let propertyName: String
    let defaultValueCloth: [String]
    let defaultValueProduct: [String]
    let defaultValueInlay: [String]
    let defaultValueColor: [String]
    let defaultPriceFrom: [String]
    let propertyValue: String
    let defaultWidth: String
    let defaultImage: String
    let defaultSize: [String]
    
    enum CodingKeys: String, CodingKey {
        case defaultName = "default_name"
        case propertyName = "property_name"
        case defaultValueCloth = "default_value_cloth"
        case defaultValueProduct = "default_value_product"
        case defaultValueInlay = "default_value_inlay"
        case defaultValueColor = "default_value_color"
        case defaultPriceFrom = "default_price_from"
        case propertyValue = "property_value"
        case defaultWidth = "default_width"
        case defaultImage = "default_image"
        case defaultSize = "default_size"
    }
}

public struct AttributeUnwrapped: Equatable, Hashable {
    public let name: String
    public let value: [String]
    
    public init(_ attribute: Attribute) {
        switch attribute.defaultName {
        case "cloth":
            name = Constants.Attributes.cloth.rawValue
            value = attribute.defaultValueCloth
                .compactMap { Constants.Attributes.clothDict[$0] }
        case "product":
            name = Constants.Attributes.product.rawValue
            value = attribute.defaultValueProduct
                .compactMap { Constants.Attributes.productDict[$0] }
        case "inlay":
            name = Constants.Attributes.inlay.rawValue
            value = attribute.defaultValueInlay
                .compactMap { Constants.Attributes.inlayDict[$0] }
        case "size":
            name = Constants.Attributes.size.rawValue
            value = attribute.defaultSize
                .compactMap { Constants.Attributes.sizeDict[$0] }
        case "wdth":
            name = Constants.Attributes.wdth.rawValue
            value = [attribute.defaultWidth]
        case "arbitrary":
            name = attribute.propertyName
            value = [attribute.propertyValue.htmlDecoded]
        case "clr":
            name = Constants.Attributes.clr.rawValue
            value = attribute.defaultValueColor
                .compactMap { Constants.Attributes.colorDict[$0] }
        default:
            fatalError()
        }
    }
    
    public init(name: String, value: [String]) {
        self.name = name
        self.value = value
    }
}
