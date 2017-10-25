import Foundation
import UIKit

@IBDesignable
open class SequenceStateButton: UIButton {
    public enum SequenceState {
        case initial, processing, success, failure
    }
    
    /// Sets the state of this SequenceStateButton
    open var sequenceState: SequenceState = .initial {
        didSet {
            updateVisuals(forState: sequenceState)
            if sequenceState == .success || sequenceState == .failure {
                resetButton(in: DispatchTime.now() + 3)
            }
        }
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return indicator
    }()
    
    /// The default image while the button's state is `SequenceState.initial`.
    @IBInspectable
    open var initialImage: UIImage? {
        didSet {
            if sequenceState == .initial {
                setImage(initialImage, for: .normal)
            }
        }
    }
    
    /// The initial color of this button.
    private var initialColor: UIColor?
    
    /// The image to be displayed while the button's state is `SequenceState.success`
    @IBInspectable
    open var successImage: UIImage?
    
    /// The color of the button when the button's state is `SequenceState.success`.
    /// If not set, will default to the initial color.
    @IBInspectable
    open var successColor: UIColor?
    
    /// The image to be displayed while the button's state is `SequenceState.failure`.
    @IBInspectable
    open var failureImage: UIImage?
    
    /// The color of the button when the button's state is `SequenceState.failure`.
    /// If not set, will default to the initial color.
    @IBInspectable
    open var failureColor: UIColor?
    
    @IBInspectable
    open var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius < 0 { cornerRadius = 0 }
            layer.cornerRadius = cornerRadius
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func resetButton(in seconds: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: seconds) { [weak self] in
            self?.sequenceState = .initial
        }
    }
    
    private func updateVisuals(forState state: SequenceState) {
        var image: UIImage?
        var color: UIColor? = backgroundColor
        
        switch state {
        case .initial:
            image = initialImage
            color = initialColor
        case .processing:
            image = nil
            initialColor = backgroundColor
        case .success:
            image = successImage
            color = successColor
        case .failure:
            image = failureImage
            color = failureColor
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setImage(image, for: .normal)
            self?.backgroundColor = color
            if self?.sequenceState == .processing {
                self?.spinner.startAnimating()
            } else {
                self?.spinner.stopAnimating()
            }
        }
    }
}
