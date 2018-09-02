import UIKit
import RealmSwift

protocol EditViewControllerProtocol: class {
    func finishedProcessing(success: Bool)
}

class EditViewController: UIViewController {
    
    private var interactor: EditViewInteractorProtocol!
    
    private var initialText: String!
    private var thought: Thought!
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!

    convenience init(interactor: EditViewInteractorProtocol) {
        self.init()
        self.interactor = interactor
    }
    
    func setup(_ thought: Thought) {
        self.thought = thought
        textView.text = thought.content
        initialText = thought.content
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        interactor.executeLogicChange(thought,
                                      save: shouldSave(initialText: initialText, finalText: textView.text),
                                      delete: shouldDelete(initialText: initialText, finalText: textView.text))
//        saveThought()
//        delegate?.tappedClose()
    }
    
    private func saveThought() {
        let realm = try! Realm()
        try! realm.write {
            thought.content = textView.text
            realm.add(thought)
        }
    }
    
    func shouldSave(initialText: String, finalText: String) -> Bool {
        return (initialText.isEmpty && !finalText.isEmpty) || (!initialText.isEmpty && initialText != finalText && !finalText.isEmpty)
    }
    
    func shouldDelete(initialText: String, finalText: String) -> Bool {
        return !initialText.isEmpty && finalText.isEmpty
    }
}

extension EditViewController: EditViewControllerProtocol {
    func finishedProcessing(success: Bool) {
        // TODO: Tell thoughts list to refresh
    }
}
