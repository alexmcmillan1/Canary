import UIKit

class ThoughtTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = String(describing: self)
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
