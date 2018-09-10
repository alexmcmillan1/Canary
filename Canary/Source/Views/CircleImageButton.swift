import UIKit

class CircleImageButton: UIButton {
    
    convenience init(_ image: UIImage?) {
        self.init()
        backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        setImage(image, for: .normal)
        imageView?.tintColor = .darkGray
        layer.cornerRadius = 30
        size(CGSize(width: 60, height: 60))
    }
}
