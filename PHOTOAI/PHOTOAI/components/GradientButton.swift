import UIKit

class GradientButton: UIButton {
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()

    var startColor: UIColor = .systemBlue {
        didSet {
            updateGradient()
        }
    }

    var endColor: UIColor = .systemPurple {
        didSet {
            updateGradient()
        }
    }

    var cornerRadius: CGFloat = 12 {
        didSet {
            updateCornerRadius()
        }
    }

    var borderWidth: CGFloat = 2 {
        didSet {
            updateBorder()
        }
    }

    var borderColor: UIColor = .black {
        didSet {
            updateBorder()
        }
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // Add property to set the icon
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            setupIconConstraints()
        }
    }

    // Add spacing property between icon and title
    var iconSpacing: CGFloat = 8

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    // MARK: - Setup
    private func setupButton() {
        // Setup gradient layer
        tintColor = .white
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)

        // Setup border layer
        borderLayer.fillColor = nil
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        layer.addSublayer(borderLayer)

        // Setup button title
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)

        addSubview(iconImageView)
        // Add touch animations
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func setupIconConstraints() {
        // Remove any existing constraints
        iconImageView.removeFromSuperview()
        addSubview(iconImageView)

        guard let titleLabel = titleLabel else { return }

        // Setup constraints
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5), // Adjust padding as needed
            iconImageView.widthAnchor.constraint(equalToConstant: 20), // Adjust size as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: iconSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Center the entire content (icon + title)
        let contentWidth = 20 + iconSpacing + (titleLabel.intrinsicContentSize.width)
        let leadingPadding = (bounds.width - contentWidth) / 2
        iconImageView.transform = CGAffineTransform(translationX: leadingPadding, y: 0)
        titleLabel.transform = CGAffineTransform(translationX: leadingPadding, y: 0)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // Update gradient frame
        gradientLayer.frame = bounds

        // Update border path
        let borderPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        borderLayer.path = borderPath.cgPath

        // Update corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        // Update icon constraints when layout changes
        if iconImage != nil {
            setupIconConstraints()
        }
    }

    // MARK: - Updates
    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
        setNeedsLayout()
    }

    private func updateBorder() {
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        setNeedsLayout()
    }

    // MARK: - Touch Animations
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
