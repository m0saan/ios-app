import UIKit

class ImageComparisonCard: UIView {
    // MARK: - Properties
    private let containerView = UIView()
    private let beforeImageView = UIImageView()
    private let afterImageView = UIImageView()
    private let sliderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "line"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var sliderPosition: CGFloat = CGFloat.random(in: 0...100)
    private var isAnimating = false
    private var displayLink: CADisplayLink?
    private var animationDirection = 1.0 // 1 for right, -1 for left

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        startAnimation()
    }

    // MARK: - Setup
    private func setupViews() {
        // Setup container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        // Setup images
        beforeImageView.translatesAutoresizingMaskIntoConstraints = false
        afterImageView.translatesAutoresizingMaskIntoConstraints = false

        beforeImageView.contentMode = .scaleAspectFill
        afterImageView.contentMode = .scaleAspectFill

        beforeImageView.clipsToBounds = true
        afterImageView.clipsToBounds = true

        containerView.addSubview(beforeImageView)
        containerView.addSubview(afterImageView)
        containerView.addSubview(sliderImageView)

        // Setup constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            beforeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            beforeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            beforeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            beforeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            afterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            afterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            afterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            afterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            sliderImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            sliderImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sliderImageView.widthAnchor.constraint(equalToConstant: 44) // Adjust based on your image size
        ])

        // Add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sliderImageView.isUserInteractionEnabled = true
        sliderImageView.addGestureRecognizer(panGesture)
    }

    // MARK: - Public Configuration
    func configure(beforeImage: String, afterImage: String) {
        if afterImage != "after", let before = URL(string: afterImage) {
            beforeImageView.sd_setImage(with: before)
        } else {
            beforeImageView.image = UIImage(named: "after")
        }

        if beforeImage != "before", let after = URL(string: beforeImage) {
            afterImageView.sd_setImage(with: after)
        } else {
            afterImageView.image = UIImage(named: "before")
        }


        // Setup initial clip
        updateClipping(at: bounds.width / 2)
    }

    // MARK: - Animation
    private func startAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateAnimation() {
        let width = bounds.width
        sliderPosition += 1 * animationDirection

        if sliderPosition >= width {
            animationDirection = -1
        } else if sliderPosition <= 0 {
            animationDirection = 1
        }

        updateClipping(at: sliderPosition)
    }

    private func updateClipping(at position: CGFloat) {
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: position, height: bounds.height)
        maskLayer.backgroundColor = UIColor.black.cgColor
        afterImageView.layer.mask = maskLayer

        sliderImageView.center.x = position
    }

    // MARK: - Gesture Handling
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.location(in: self)

        switch gesture.state {
        case .began:
            displayLink?.isPaused = true
        case .changed:
            updateClipping(at: translation.x)
        case .ended, .cancelled:
            displayLink?.isPaused = false
        default:
            break
        }
    }

    // MARK: - Cleanup
    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }
}
