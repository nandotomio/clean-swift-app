import XCTest
import Main

class SignUpIntegrationTests: XCTestCase {
    func test_UI_presentation_integration() {
        debugPrint("=======================")
        debugPrint(Environment.variable(.apiBaseUrl))
        debugPrint("=======================")
        let sut = SignUpComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
