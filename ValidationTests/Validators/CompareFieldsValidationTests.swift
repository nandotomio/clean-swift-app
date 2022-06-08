import XCTest
import Validation
import Presentation

class CompareFieldsValidationTests: XCTestCase {
    func test_validate_should_return_error_if_field_is_not_provided() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Password Confirmation")
        let errorMessage = sut.validate(data: ["password": "any_password", "passwordConfirmation": "wrong_password"])
        XCTAssertEqual(errorMessage, "Password Confirmation is invalid")
    }
    
    func test_validate_should_return_error_with_correct_field_label() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Password")
        let errorMessage = sut.validate(data: ["password": "any_password", "passwordConfirmation": "wrong_password"])
        XCTAssertEqual(errorMessage, "Password is invalid")
    }
    
    func test_validate_should_return_nil_if_comparation_succeeds() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Password Confirmation")
        let errorMessage = sut.validate(data: ["password": "any_password", "passwordConfirmation": "any_password"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_message_if_no_data_is_provided() {
        let sut = makeSut(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Password Confirmation")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "Password Confirmation is invalid")
    }
}

extension CompareFieldsValidationTests {
    func makeSut(fieldName: String, fieldNameToCompare: String, fieldLabel: String, file: StaticString = #filePath, line: UInt = #line) -> Validation {
        let sut = CompareFieldsValidation(fieldName: fieldName, fieldNameToCompare: fieldNameToCompare, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
