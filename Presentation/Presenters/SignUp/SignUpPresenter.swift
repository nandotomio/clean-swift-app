import Foundation
import Domain

public class SignUpPresenter {
    private let alertView: AlertView
    private let addAccount: AddAccount
    private let loadingView: LoadingView
    private let validation: Validation
    
    public init (alertView: AlertView, addAccount: AddAccount, loadingView: LoadingView, validation: Validation) {
        self.alertView = alertView
        self.addAccount = addAccount
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func signUp(viewModel: SignUpRequest) {
        if let message = validation.validate(data: viewModel.toJSON()) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Validation failed", message: message))
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: viewModel.toAddAccountModel()) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .emailInUse:
                        errorMessage = "Email already in use."
                    default:
                        errorMessage = "Oops, something went wrong. Please try again later."
                    }
                    self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: errorMessage))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Success", message: "Account created with success!"))
                }                
            }
        }
    }
}
