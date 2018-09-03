
import UIKit


extension String {
    public var isValid: Bool {
        if isBlank == false && count > 0 {
            return true
        }
        return false
    }
    
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }

    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    mutating func urlEncode() {
        self = urlEncoded()
    }
}

