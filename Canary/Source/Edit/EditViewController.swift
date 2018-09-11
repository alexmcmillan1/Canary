import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    private var id: String?
    private var text: String?
    weak var delegate: EditorDelegate?
    
    @IBOutlet weak private var textView: UITextView!    
    @IBOutlet weak private var closeButton: CircleImageButton!
    @IBOutlet weak private var textViewBottomConstraint: NSLayoutConstraint!
    
    convenience init(id: String? = nil, text: String? = nil) {
        self.init(nibName: "EditView", bundle: Bundle.main)
        self.id = id
        self.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        textView.delegate = self
        closeButton.size(CGSize(width: 44, height: 44))
        closeButton.layer.cornerRadius = 22
        registerForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if textView.text.isEmpty {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction private func tappedClose(_ sender: Any) {
        textView.resignFirstResponder()
        
        if text == nil && !textView.text.isEmpty {
            // save as new
            let id = UUID().uuidString
            saveThought(id: id, content: textView.text)
        } else if let id = id, text != nil && textView.text != text {
            // save as modified
            saveThought(id: id, content: textView.text)
        } else if let id = id, text != nil && textView.text.isEmpty {
            // delete
            deleteThought(id: id)
        }
        
        delegate?.tappedClose()
        dismiss(animated: true)
    }
    
    private func saveThought(id: String, content: String) {
        let realm = try! Realm()
        try! realm.write {
            let thought = Thought.create(id: id, content: content)
            thought.lastUpdated = Date().timeIntervalSince1970
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
    
    private func animateCloseButton(image: UIImage?) {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            self.closeButton.transform = self.closeButton.transform.scaledBy(x: 0.9, y: 0.9)
        }
        
        let secondAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5) {
            self.closeButton.transform = .identity
        }
        
        animator.addCompletion { _ in
            self.closeButton.setImage(image, for: .normal)
            secondAnimator.startAnimation()
        }
        
        animator.startAnimation()
    }
}

extension EditViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        let oldImage = closeButton.imageView?.image
        let newImage = newText.isEmpty ? UIImage(named: "cross") : UIImage(named: "check")
        
        if newImage != oldImage {
            animateCloseButton(image: newImage)
        }
        
        return true
    }
}

extension EditViewController {
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    private func deregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            textViewBottomConstraint.constant = keyboardHeight
        }
    }
}
