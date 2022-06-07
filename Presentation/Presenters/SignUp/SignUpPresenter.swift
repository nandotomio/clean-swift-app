import Foundation
import Domain

public class SignUpPresenter {
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    
    public init (alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
        self.loadingView = loadingView
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Validation failed", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: SignUpMapper.toAddAccountModel(viewModel: viewModel)) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: "Oops, something went wrong. Please try again later."))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Success", message: "Account created with success!"))
                }                
            }
        }
    }
    
    private func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "Name is required"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "Email is required"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "Password is required"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "Password confirmation is required"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "Password confirmation is invalid"
        } else if !emailValidator.isValid(email: viewModel.email!) {
            return "Email is invalid"
        }
        return nil
    }
}
