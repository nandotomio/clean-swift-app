import XCTest
import Presentation
import Domain

class LoginPresenterTests: XCTestCase {
    func test_login_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: viewModel.toJSON()!))
    }
    
    func test_login_should_show_error_msg_if_validation_fails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(validation: validationSpy, alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Validation failed", message: "Any error message"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_call_authentication_with_correct_values() {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy)
        sut.login(viewModel: makeLoginViewModel())
        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }
    
    func test_login_should_show_generic_error_msg_if_authentication_fails() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Oops, something went wrong. Please try again later."))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_expired_session_error_msg_if_authentication_returns_unauthorized() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Invalid credentials."))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.expiredSession)
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_success_msg_if_authentication_succeeds() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Success", message: "Login success!"))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_show_loading_before_and_after_authentication() {
        let loadingViewSpy = LoadingViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

extension LoginPresenterTests {
    func makeSut(validation: ValidationSpy = ValidationSpy(), alertView: AlertViewSpy = AlertViewSpy(), authentication: AuthenticationSpy = AuthenticationSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), file: StaticString = #filePath, line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(validation: validation, alertView: alertView, authentication: authentication, loadingView: loadingView)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}

