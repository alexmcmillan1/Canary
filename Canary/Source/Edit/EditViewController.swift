import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    private var id: String?
    private var text: String?
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!    
    @IBOutlet weak private var closeButton: UIButton!
    
    convenience init(id: String? = nil, text: String? = nil) {
        self.init(nibName: "EditView", bundle: Bundle.main)
        self.id = id
        self.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textView.delegate = self
        textView.textColor = .appBlue
        view.backgroundColor = .appYellowLight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        
        // if text !empty, text view empty >>> delete
        // if text empty, text view empty >>> dismiss
        
        if text != nil {
            if textView.text.isEmpty {
                if let id = id {
                    deleteThought(id: id)
                }
            } else {
                // save thought
                let id = self.id ?? UUID().uuidString
                saveThought(id: id, content: textView.text)
            }
        }
        
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
    
    private func deleteThought(id: String) {
        let realm = try! Realm()
        try! realm.write {
            let thought = Thought.create(id: id, content: text!)
            realm.delete(thought)
        }
    }
}

extension EditViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        closeButton.setImage(newText.isEmpty ? #imageLiteral(resourceName: "cross") : #imageLiteral(resourceName: "check"), for: .normal)
        return true
    }
}
