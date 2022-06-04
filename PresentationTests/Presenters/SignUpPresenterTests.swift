import XCTest
import Presentation

class SignUpPresenterTests: XCTestCase {
    func test_signUp_should_show_error_msg_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Name is required"))
    }
    
    func test_signUp_should_show_error_msg_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Email is required"))
    }
    
    func test_signUp_should_show_error_msg_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Password is required"))
    }
    
    func test_signUp_should_show_error_msg_if_passwordConfirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Password confirmation is required"))
    }
    
    func test_signUp_should_show_error_msg_if_passwordConfirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "wrong_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Failed to confirm password"))
    }
    
    func test_signUp_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_msg_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "invalid_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
        emailValidatorSpy.result = false
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Invalid email"))
    }
}

extension SignUpPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        return SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var email: String?
        var result = true
        
        func isValid(email: String) -> Bool {
            self.email = email
            return self.result
        }
    }
}
