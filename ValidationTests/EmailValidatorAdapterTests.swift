import XCTest
import Presentation

public final class EmailValidatorAdapter: EmailValidator {
    private let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public func isValid(email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
}

class EmailValidatorAdapterTests: XCTestCase {
    func test_invalid_emails() {
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: "ab"))
        XCTAssertFalse(sut.isValid(email: "ab@"))
        XCTAssertFalse(sut.isValid(email: "ab@cd"))
        XCTAssertFalse(sut.isValid(email: "ab@cd."))
        XCTAssertFalse(sut.isValid(email: "@ab.com"))
    }
    
    func test_valid_emails() {
        let sut = EmailValidatorAdapter()
        XCTAssertTrue(sut.isValid(email: "ab@cd.com"))
        XCTAssertTrue(sut.isValid(email: "test@test.com.br"))
    }
}
