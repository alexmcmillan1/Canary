import UIKit

class ActionOverlayView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView = UIImageView()
    
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
        
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "delete_cancel")
        
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 72).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60)
        imageView.widthAnchor.constraint(equalToConstant: 60)
    }
}
