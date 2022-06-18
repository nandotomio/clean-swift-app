import Foundation
import UI
import Presentation
import Validation
import Domain

public func makeSignUpController() -> SignUpViewController {
    return makeSignUpControllerWith(addAccount: makeRemoteAddAccount())
}

public func makeSignUpControllerWith(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeSignUpValidations())
    let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), addAccount: addAccount, loadingView: WeakVarProxy(controller), validation: validationComposite)
    controller.signUp = presenter.signUp
    return controller
}

public func makeSignUpValidations() -> [Validation] {
    return [
        RequiredFieldValidation(fieldName: "name", fieldLabel: "Name"),
        RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
        EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
        RequiredFieldValidation(fieldName: "password", fieldLabel: "Password"),
        RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Password Confirmation"),
        CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Password Confirmation")
    ]
}
