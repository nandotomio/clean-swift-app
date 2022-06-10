import Foundation
import Domain

public class LoginPresenter {
    private let validation: Validation
    private let alertView: AlertView
    private let authentication: Authentication
    
    public init (validation: Validation, alertView: AlertView, authentication: Authentication) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJSON()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Validation failed", message: message))
        } else {
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .expiredSession:
                        errorMessage = "Invalid credentials."
                    default:
                        errorMessage = "Oops, something went wrong. Please try again later."
                    }
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: errorMessage))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Success", message: "Login success!"))
                }
            }
        }
    }
}
