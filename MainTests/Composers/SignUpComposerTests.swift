import XCTest
import Main

class SignUpComposerTests: XCTestCase {
    func test_UI_presentation_integration() {
        let sut = SignUpComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
