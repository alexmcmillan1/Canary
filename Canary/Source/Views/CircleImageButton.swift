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
    
    func animateToImage(_ image: UIImage?, immediately: Bool = false) {
        if immediately {
            self.setImage(image, for: .normal)
        }
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            self.transform = self.transform.scaledBy(x: 0.9, y: 0.9)
        }
        
        let secondAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5) {
            self.transform = .identity
        }
        
        animator.addCompletion { _ in
            if !immediately {
                self.setImage(image, for: .normal)
            }
            secondAnimator.startAnimation()
        }
        
        animator.startAnimation()
    }
}
