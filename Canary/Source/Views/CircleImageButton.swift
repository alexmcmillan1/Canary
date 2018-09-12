import UIKit

class CircleImageButton: UIButton {
    
    private var image: UIImage? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(_ image: UIImage?) {
        self.init(frame: .zero)
        self.image = image
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor(white: 0.95, alpha: 0.8)
        if imageView?.image == nil {
            setImage(image, for: .normal)
        }
        imageView?.tintColor = .darkGray
        layer.cornerRadius = 30
        size(CGSize(width: 60, height: 60))
    }
}
