import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    private var thoughtId: String?
    private var thoughtContent: String?
    private var alreadyExists: Bool? = false
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!
    
    func setup(_ thought: Thought = Thought.create(), alreadyExists: Bool = false) {
        thoughtId = thought.id
        thoughtContent = thought.content
        self.alreadyExists = alreadyExists
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = thoughtContent
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        saveThought()
        delegate?.tappedClose()
        dismiss(animated: true)
    }
    
    private func saveThought() {
        let realm = try! Realm()
        try! realm.write {
            let thought = Thought.create(textView.text)
            realm.add(thought)
        }
    }
    
}
