import UIKit

class ThoughtTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = String(describing: self)
    
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
