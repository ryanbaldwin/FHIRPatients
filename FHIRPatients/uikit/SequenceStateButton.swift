import Foundation
import UIKit

/// A UIButton which has 4 states: `initial`, `processing`, `success`, and `failure`,
/// appropriate for representing asynchronous actions, such as submitting an
/// HTTP request.
///
/// - Attention: With the exception of `SequenceStateButton.initial`, it is necessary for the target managing the
///              button's action to appropriate set the button's state.
@IBDesignable
open class SequenceStateButton: UIButton {
    
    /// Represents the current state of this button
    public enum SequenceState {
        /// The button is in its initial state, displaying it's default image and background color.
        case initial,
        
        /// The button has been tapped and is awaiting its operation to complete.
        /// This state maintains the initial background color, and shows a UIActivityIndicator in place of the image.
        /// While `processing` the button is disabled.
        ///
        /// - Attention: It is necessary for the administer of the operation to set this button's state upon completion.
        processing,
        
        /// The operation completed successfull, and the button's successImage and successColor are displayed.
        /// The button will reset to the initial state automatically in 3 seconds.
        ///
        /// - Attention: It is necessary for the administer of the operation to set this button's state upon completion.
        success,
        
        /// the operation completed in error, and the button's successImage and successColor are displayed.
        /// The button will reset to the initial state automatically in 3 seconds.
        ///
        /// - Attention: It is necessary for the administer of the operation to set this button's state upon completion.
        failure
    }
    
    /// Sets the state of this SequenceStateButton and appropriately transitions the UI.
    open var sequenceState: SequenceState = .initial {
        didSet {
            updateVisuals(forState: sequenceState)
            switch sequenceState {
            case .initial:
                isEnabled = true
            case .success, .failure:
                resetButton(in: DispatchTime.now() + 3)
                fallthrough
            default:
                isEnabled = false
            }
            if sequenceState == .success || sequenceState == .failure {
                resetButton(in: DispatchTime.now() + 3)
            }
        }
    }
    
    /// Lazily creates the UIActivityIndicator displayed when the button's state has transitioned into `processing`
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
    
    /// Resets this button's state back to `initial`.
    ///
    /// - Parameter seconds: The number of seconds between now and the time the button should reset.
    private func resetButton(in seconds: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: seconds) { [weak self] in
            self?.sequenceState = .initial
        }
    }
    
    /// Transitions this button's image and background colour to those appropriate for the given state.
    ///
    /// - Parameter state: The state for which the visuals are to be updated to represet.
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
