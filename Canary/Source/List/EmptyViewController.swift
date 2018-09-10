import UIKit

class EmptyViewController: UIViewController {
    
    @IBOutlet weak private var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = NSLocalizedString("Dream something up", comment: "")
    }
}
