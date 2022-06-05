import Foundation
import Presentation

class EmailValidatorSpy: EmailValidator {
    var email: String?
    var result = true
    
    func isValid(email: String) -> Bool {
        self.email = email
        return self.result
    }
    
    func simulateInvalidEmail() {
        self.result = false
    }
}
