import XCTest
@testable import Canary

class CanaryTests: XCTestCase {
    
    private var mockInteractor = MockEditViewInteractor()
    private var editViewController: EditViewController!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockEditViewInteractor()
        editViewController = EditViewController(interactor: mockInteractor)
    }

    func test_wasEmpty_nowEmpty_closeLogicCorrect() {
        let shouldSave = editViewController.shouldSave(initialText: "", finalText: "")
        let shouldDelete = editViewController.shouldDelete(initialText: "", finalText: "")
        mockInteractor.executeLogicChange(Thought.create(), save: shouldSave, delete: shouldDelete)
        XCTAssertTrue(mockInteractor.executeLogicChangeCalled)
        XCTAssert(mockInteractor.save == false)
        XCTAssert(mockInteractor.delete == false)
    }
    
    func test_wasEmpty_nowNotEmpty_closeLogicCorrect() {
        let shouldSave = editViewController.shouldSave(initialText: "", finalText: "A")
        let shouldDelete = editViewController.shouldDelete(initialText: "", finalText: "A")
        mockInteractor.executeLogicChange(Thought.create(), save: shouldSave, delete: shouldDelete)
        XCTAssertTrue(mockInteractor.executeLogicChangeCalled)
        XCTAssert(mockInteractor.save == true)
        XCTAssert(mockInteractor.delete == false)
    }
    
    func test_wasNotEmpty_nowEmpty_closeLogicCorrect() {
        let shouldSave = editViewController.shouldSave(initialText: "A", finalText: "")
        let shouldDelete = editViewController.shouldDelete(initialText: "A", finalText: "")
        mockInteractor.executeLogicChange(Thought.create(), save: shouldSave, delete: shouldDelete)
        XCTAssertTrue(mockInteractor.executeLogicChangeCalled)
        XCTAssert(mockInteractor.save == false)
        XCTAssert(mockInteractor.delete == true)
    }
}

class MockEditViewInteractor: EditViewInteractorProtocol {
    
    var executeLogicChangeCalled = false
    var save = false
    var delete = false
    
    func executeLogicChange(_ thought: Thought, save: Bool, delete: Bool) {
        executeLogicChangeCalled = true
        self.save = save
        self.delete = delete
    }
}
