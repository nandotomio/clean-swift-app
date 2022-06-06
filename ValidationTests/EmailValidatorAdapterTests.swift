import XCTest
import Presentation
import Validation

class EmailValidatorAdapterTests: XCTestCase {
    func test_invalid_emails() {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "ab"))
        XCTAssertFalse(sut.isValid(email: "ab@"))
        XCTAssertFalse(sut.isValid(email: "ab@cd"))
        XCTAssertFalse(sut.isValid(email: "ab@cd."))
        XCTAssertFalse(sut.isValid(email: "@ab.com"))
    }
    
    func test_valid_emails() {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "ab@cd.com"))
        XCTAssertTrue(sut.isValid(email: "test@test.com.br"))
    }
}

extension EmailValidatorAdapterTests {
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
