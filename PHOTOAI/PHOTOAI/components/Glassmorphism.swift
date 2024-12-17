//
//  Glassmorphism.swift
//  PHOTOAI
//
//  Created by zakar on 17/12/2024.
//

import UIKit

class AIGlassmorphismBackground: UIView {
    private let gradientLayer1 = CAGradientLayer()
    private let gradientLayer2 = CAGradientLayer()
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Setup base background color
        backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Add blur view
        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Configure gradient layers
        setupGradientLayers()

        // Start animation
        startAnimation()
    }

    private func setupGradientLayers() {
        // First gradient (red tones)
        gradientLayer1.colors = [
            UIColor(red: 1, green: 0, blue: 0, alpha: 0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer1.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer1)

        // Second gradient (blue tones)
        gradientLayer2.colors = [
            UIColor(red: 0, green: 0.5, blue: 1, alpha: 0.5).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer2.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer2.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer2.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer2)

        // Add initial transforms
        gradientLayer1.transform = CATransform3DMakeScale(1.5, 1.5, 1)
        gradientLayer2.transform = CATransform3DMakeScale(1.5, 1.5, 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update gradient frames
        let largerFrame = bounds.insetBy(dx: -bounds.width/2, dy: -bounds.height/2)
        gradientLayer1.frame = largerFrame
        gradientLayer2.frame = largerFrame
    }

    private func startAnimation() {
        startTime = CACurrentMediaTime()

        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateAnimation() {
        let currentTime = CACurrentMediaTime()
        let elapsed = currentTime - startTime

        // Create flowing motion using sine waves
        let phase1 = sin(elapsed * 0.5)
        let phase2 = cos(elapsed * 0.3)

        // Animate first gradient
        let transform1 = CATransform3DConcat(
            CATransform3DMakeScale(1.5 + 0.2 * phase1, 1.5 + 0.2 * phase1, 1),
            CATransform3DMakeRotation(0.1 * phase1, 0, 0, 1)
        )
        gradientLayer1.transform = transform1

        // Animate second gradient
        let transform2 = CATransform3DConcat(
            CATransform3DMakeScale(1.5 + 0.2 * phase2, 1.5 + 0.2 * phase2, 1),
            CATransform3DMakeRotation(0.1 * phase2, 0, 0, 1)
        )
        gradientLayer2.transform = transform2
    }

    deinit {
        displayLink?.invalidate()
    }
}

// Extension to add glass effect to any view
extension UIView {
    func addGlassEffect(style: UIBlurEffect.Style = .dark, alpha: CGFloat = 0.8) {
        backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = alpha

        insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
