import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    private var id: String?
    private var text: String?
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!
    
    convenience init(id: String? = nil, text: String? = nil) {
        self.init(nibName: "EditView", bundle: Bundle.main)
        self.id = id
        self.text = text
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        
        let resolvedId = id ?? UUID().uuidString
        saveThought(id: resolvedId, content: textView.text)
        
        delegate?.tappedClose()
        dismiss(animated: true)
    }
    
    private func saveThought(id: String, content: String) {
        let realm = try! Realm()
        try! realm.write {
            let thought = Thought.create(id: id, content: content)
            realm.add(thought, update: true)
        }
    }
    
}
