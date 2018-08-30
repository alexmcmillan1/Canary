import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    @IBOutlet weak private var promptLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    
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
            let thought = Thought.withContent(textView.text)
            realm.add(thought)
        }
        dismiss(animated: true, completion: nil)
    }
}
