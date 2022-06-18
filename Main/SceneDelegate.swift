import Foundation
import UIKit
import UI
import Data

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let signUpFactory: () -> SignUpViewController = {
        let alamofireAdapter = makeAlamofireAdapter()
        let addAccount = makeRemoteAddAccount(httpClient: alamofireAdapter)
        return makeSignUpController(addAccount: addAccount)
    }
    
    private let loginFactory: () -> LoginViewController = {
        let alamofireAdapter = makeAlamofireAdapter()
        let authentication = makeRemoteAuthentication(httpClient: alamofireAdapter)
        return makeLoginController(authentication: authentication)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let nav = NavigationController()
        let welcomeRouter = WelcomeRouter(nav: nav, loginFactory: loginFactory, signUpFactory: signUpFactory)
        let welcomeViewController = WelcomeViewController.instantiate()
        welcomeViewController.signUp = welcomeRouter.gotoSignUp
        welcomeViewController.login = welcomeRouter.gotoLogin
        nav.setRootViewController(viewController: welcomeViewController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
