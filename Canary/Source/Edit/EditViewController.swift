import UIKit
import RealmSwift

protocol EditViewControllerProtocol: class {
    func executeLogic()
}

class EditViewController: UIViewController, UITextViewDelegate {
    
    private var thoughtId: String!
    private var initialText: String!
    private var priorImminentAction: EditAction = .Cancel
    private var imminentAction: EditAction = .Cancel
    
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!
    
    func setup(_ thought: Thought) {
        thoughtId = thought.id
        initialText = thought.content
        textView.text = initialText
        textView.delegate = self
    }
    
    func shouldSave() -> Bool {
        return (initialText.isEmpty && !textView.text.isEmpty) || (!initialText.isEmpty && initialText != textView.text && !textView.text.isEmpty)
    }
    
    func shouldDelete() -> Bool {
        return !initialText.isEmpty && textView.text.isEmpty
    }

    @IBAction func didpan(_ sender: Any) {
        textView.resignFirstResponder()
        if let panGestureRecognizer = sender as? UIPanGestureRecognizer {
            delegate?.panned(panGestureRecognizer)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let shouldSave = self.shouldSave()
        let shouldDelete = self.shouldDelete()
        
        imminentAction = shouldSave ? .Save : shouldDelete ? .Delete : .Cancel
        
        if priorImminentAction != imminentAction {
            delegate?.imminentActionChanged(imminentAction)
        }
        
        priorImminentAction = imminentAction
        
        return true
    }
}

extension EditViewController: EditViewControllerProtocol {
    
    func executeLogic() {
        textView.resignFirstResponder()

        let realm = try! Realm()
        
        try! realm.write {
            let thought = Thought.create(textView.text)
            thought.id = thoughtId
            if shouldSave() {
                realm.add(thought)
            } else if shouldDelete() {
                realm.delete(thought)
            }
        }
        
        delegate?.refreshData()
    }
}
