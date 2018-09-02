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
        let closeLogic = getCloseLogic(initialText: initialText, finalText: textView.text)
        interactor.executeLogicChange(thought, save: closeLogic.save, delete: closeLogic.delete)
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
    
    func getCloseLogic(initialText: String, finalText: String) -> (save: Bool, delete: Bool) {
        var save = false
        var delete = false
        
        if initialText.isEmpty {
            if finalText.isEmpty {
                // Close and do not save.
                save = false
                delete = false
            } else {
                // Save and close.
                save = true
                delete = false
            }
        } else {
            if finalText.isEmpty {
                // Delete and close.
                save = false
                delete = true
            } else {
                if finalText != initialText {
                    // Text has changed. Save and close.
                    save = true
                    delete = false
                } else {
                    // Text has not changed. Close.
                    save = false
                    delete = false
                }
            }
        }
        
        return (save, delete)
    }
}

extension EditViewController: EditViewControllerProtocol {
    func finishedProcessing(success: Bool) {
        // TODO: Tell thoughts list to refresh
    }
}
