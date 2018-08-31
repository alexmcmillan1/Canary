import UIKit
import RealmSwift

class InputViewController: UIViewController, UITextViewDelegate {
    
    private let checkImage = #imageLiteral(resourceName: "baseline_check_black_36pt")
    private let crossImage = #imageLiteral(resourceName: "baseline_close_black_36pt")
    private let characterLimit = 50
    
    @IBOutlet weak private var promptLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareAnimations()
        executeAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    private func prepareAnimations() {
        promptLabel.transform = promptLabel.transform.translatedBy(x: 0, y: 50)
        textView.transform = textView.transform.translatedBy(x: 0, y: 75)
    }
    
    private func executeAnimations() {
        UIView.animate(withDuration: 1.0) {
            self.promptLabel.transform = .identity
            self.textView.transform = .identity
        }
    }
    
    @IBAction private func tappedDone(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            let thought = Thought.create(textView.text)
            realm.add(thought)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if textView.text.isEmpty && !newText.isEmpty {
            closeButton.setImage(checkImage, for: .normal)
        } else if !textView.text.isEmpty && newText.isEmpty {
            closeButton.setImage(crossImage, for: .normal)
        }
        
        return newText.count <= characterLimit
    }
}
