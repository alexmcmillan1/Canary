import UIKit
import RealmSwift

protocol EditViewControllerProtocol: class {
    func finishedProcessing(success: Bool)
    func executeLogic()
}

class EditViewController: UIViewController, UITextViewDelegate {
    
    private var interactor: EditViewInteractorProtocol!
    private var initialText: String!
    private var thought: Thought!
    private var previousImminentAction: EditAction = .Cancel
    private var imminentAction: EditAction = .Cancel
    
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
        textView.delegate = self
    }
    
    // This will become redundant if panning becomes the only way to close
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        interactor.executeLogicChange(thought, save: shouldSave(initialText: initialText, finalText: textView.text),
                                      delete: shouldDelete(initialText: initialText, finalText: textView.text))
//        saveThought()
        delegate?.tappedClose()
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

    @IBAction func didpan(_ sender: Any) {
        if let panGestureRecognizer = sender as? UIPanGestureRecognizer {
            delegate?.panned(panGestureRecognizer)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let shouldSave = self.shouldSave(initialText: textView.text, finalText: finalText)
        let shouldDelete = self.shouldDelete(initialText: textView.text, finalText: finalText)
        
        imminentAction = shouldSave ? .Save : shouldDelete ? .Delete : .Cancel
        
        if previousImminentAction != imminentAction {
            delegate?.imminentActionChanged(imminentAction)
        }
        
        previousImminentAction = imminentAction
        
        return true
    }
}

extension EditViewController: EditViewControllerProtocol {
    
    func finishedProcessing(success: Bool) {
        // TODO: Tell thoughts list to refresh
    }
    
    func executeLogic() {
        interactor.executeLogicChange(thought, save: shouldSave(initialText: initialText, finalText: textView.text),
                                      delete: shouldDelete(initialText: initialText, finalText: textView.text))
    }
}
