import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    private var thought: Thought!
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    
    func setup(_ thought: Thought) {
        self.thought = thought
        titleLabel.text = thought.title
        textView.text = thought.content
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        saveThought()
        delegate?.tappedClose()
    }
    
    private func saveThought() {
        let realm = try! Realm()
        try! realm.write {
            thought.content = textView.text
            realm.add(thought)
        }
    }
    
}
