import Foundation
import Presentation

public final class CompareFieldsValidation: Validation, Equatable {
    private let fieldName: String
    private let fieldNameToCompare: String
    private let fieldLabel: String
    
    public init (fieldName: String, fieldNameToCompare: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldNameToCompare = fieldNameToCompare
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let fieldValue = data?[fieldName] as? String, let fieldValueToCompare = data?[fieldNameToCompare] as? String, fieldValue == fieldValueToCompare else { return "\(fieldLabel) is invalid" }
        return nil
    }
    
    public static func == (lhs: CompareFieldsValidation, rhs: CompareFieldsValidation) -> Bool {
        return lhs.fieldName == rhs.fieldName && lhs.fieldLabel == rhs.fieldLabel && lhs.fieldNameToCompare == rhs.fieldNameToCompare
    }
}
