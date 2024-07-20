public enum NetworkError: Error {
    case decode
    case generic
    case invalidURL
    case noResponse
    case unexpectedStatusCode
    case unknown
    
    public var customMessage: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .generic:
            return "Generic Error"
        case .invalidURL:
            return "Invalid URL Error"
        case .noResponse:
            return "No Response"
        case .unexpectedStatusCode:
            return "Status Code Error"
        default:
            return "Unknown Error"
        }
    }
}
