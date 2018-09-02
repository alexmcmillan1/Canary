import UIKit
import RealmSwift

protocol EditViewControllerProtocol: class {
    func finishedProcessing(success: Bool)
    func executeLogic()
}

class EditViewController: UIViewController, UITextViewDelegate {
    
    private var initialText: String!
    private var thought: Thought!
    private var previousImminentAction: EditAction = .Cancel
    private var imminentAction: EditAction = .Cancel
    private var editedText: String?
    
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!
    
    func setup(_ thought: Thought) {
        self.thought = thought
        textView.text = thought.content
        initialText = thought.content
        textView.delegate = self
    }
    
    func shouldSave() -> Bool {
        return (initialText.isEmpty && !textView.text.isEmpty) || (!initialText.isEmpty && initialText != textView.text && !textView.text.isEmpty)
    }
    
    func shouldDelete() -> Bool {
        return !initialText.isEmpty && textView.text.isEmpty
    }

    @IBAction func didpan(_ sender: Any) {
        if let panGestureRecognizer = sender as? UIPanGestureRecognizer {
            delegate?.panned(panGestureRecognizer)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let shouldSave = self.shouldSave()
        let shouldDelete = self.shouldDelete()
        
        imminentAction = shouldSave ? .Save : shouldDelete ? .Delete : .Cancel
        
        if previousImminentAction != imminentAction {
            delegate?.imminentActionChanged(imminentAction)
        }
        
        editedText = finalText
        previousImminentAction = imminentAction
        
        return true
    }
}

extension EditViewController: EditViewControllerProtocol {
    
    func finishedProcessing(success: Bool) {
        delegate?.refreshData()
    }
    
    func executeLogic() {
        textView.resignFirstResponder()

        let realm = try! Realm()
        
        try! realm.write {
            if shouldSave() {
                if initialText.isEmpty {
                    realm.add(thought)
                } else {
                    thought.content = textView.text
                }
            } else if shouldDelete() {
                realm.delete(thought)
            }
        }
    }
}
