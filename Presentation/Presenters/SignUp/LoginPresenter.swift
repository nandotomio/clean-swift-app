import Foundation
import Domain

public class LoginPresenter {
    private let validation: Validation
    private let alertView: AlertView
    private let authentication: Authentication
    private let loadingView: LoadingView
    
    public init (validation: Validation, alertView: AlertView, authentication: Authentication, loadingView: LoadingView) {
        self.validation = validation
        self.alertView = alertView
        self.authentication = authentication
        self.loadingView = loadingView
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJSON()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Validation failed", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            authentication.auth(authenticationModel: viewModel.toAuthenticationModel()) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
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
