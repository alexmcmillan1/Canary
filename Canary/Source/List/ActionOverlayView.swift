import UIKit

class ActionOverlayView: UIView {
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    private func privateInit() {
        isUserInteractionEnabled = false
        
        alpha = 0
        backgroundColor = .white
        
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        text = "Cancel"
        
        addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
