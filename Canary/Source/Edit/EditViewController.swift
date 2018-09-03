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
    
    private var willSave: Bool = false
    private var willDelete: Bool = false
    
    weak var delegate: EditorDelegate?
    
    @IBOutlet var dismissPanGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var appearPanGestureRecognizer: UIPanGestureRecognizer!
    
    
    @IBOutlet weak private var textView: UITextView!
    
    func setup(_ thought: Thought) {
        thoughtId = thought.id
        initialText = thought.content
        textView.text = initialText
        textView.delegate = self
    }
    
    func shouldSave(modifiedText: String) -> Bool {
        return (initialText.isEmpty && !modifiedText.isEmpty) || (!initialText.isEmpty && initialText != modifiedText && !modifiedText.isEmpty)
    }
    
    func shouldDelete(modifiedText: String) -> Bool {
        return !initialText.isEmpty && modifiedText.isEmpty
    }

    @IBAction func didPanToDismiss(_ sender: Any) {
        textView.resignFirstResponder()
        if let panGestureRecognizer = sender as? UIPanGestureRecognizer {
            delegate?.pannedToDismiss(panGestureRecognizer)
        }
    }
    
    @IBAction func didPanToAppear(_ sender: Any) {
        if let panGestureRecognizer = sender as? UIPanGestureRecognizer {
            delegate?.pannedToAppear(panGestureRecognizer)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        willSave = self.shouldSave(modifiedText: finalText)
        willDelete = self.shouldDelete(modifiedText: finalText)
        
        imminentAction = willSave ? .Save : willDelete ? .Delete : .Cancel
        
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
            if willSave {
                realm.add(thought)
            } else if willDelete {
                realm.delete(thought)
            }
        }
        
        delegate?.refreshData()
    }
}
