//
//  InputTableViewCell.swift
//  PHOTOAI
//
//  Created by zakar on 17/12/2024.
//

import UIKit
class InputTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier =  "inputTableViewCell"

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prompt To Image"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 25)
        return label
    }()

    private let textView: PlaceholderTextView = {
        let view = PlaceholderTextView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        view.layer.cornerRadius = 12
        view.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 8, right: 12)
        return view
    }()

    private lazy var gradientButton: GradientButton = {
        let button = GradientButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.startColor = UIColor(named: "gradient1") ?? .systemBlue
        button.endColor = UIColor(named: "gradient2") ?? .systemPurple
        button.borderWidth = 0 // Remove border since we want only gradient
        button.cornerRadius = 12
        return button
    }()

    private lazy var randomPrompt: GradientButton = {
        let button = GradientButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Random Prompt", for: .normal)
        button.startColor = .clear
        button.endColor = .clear
        button.borderWidth = 1 // Remove border since we want only gradient
        button.borderColor = .white
        button.cornerRadius = 12
        return button
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let patternView = DottedPatternView()

    // MARK: - Setup
    private func setupCell() {
        // Configure cell appearance
        backgroundColor = .clear
        selectionStyle = .none
        
        // Add subviews
        contentView.addSubview(label)
        contentView.addSubview(textView)
        contentView.addSubview(randomPrompt)
        patternView.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(patternView)
        randomPrompt.iconImage = UIImage(named: "random")!.withRenderingMode(.alwaysTemplate) // Set your
        contentView.addSubview(gradientButton)
        gradientButton.iconImage = UIImage(named: "gallery")!.withRenderingMode(.alwaysTemplate) // Set your icon from assets
        // Setup constraints

        NSLayoutConstraint.activate([
            // TextField constraints
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 200),

            patternView.widthAnchor.constraint(equalTo: textView.widthAnchor),
            patternView.heightAnchor.constraint(equalTo: textView.heightAnchor),
            // Button constraints
            gradientButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            gradientButton.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: 0.49),
            gradientButton.leftAnchor.constraint(equalTo: textView.leftAnchor),
            gradientButton.heightAnchor.constraint(equalToConstant: 50),

            randomPrompt.widthAnchor.constraint(equalTo: gradientButton.widthAnchor),
            randomPrompt.heightAnchor.constraint(equalTo: gradientButton.heightAnchor),
            randomPrompt.topAnchor.constraint(equalTo: gradientButton.topAnchor),
            randomPrompt.rightAnchor.constraint(equalTo: textView.rightAnchor)
        ])

    }
    
    // MARK: - Public Configuration
    func configure(placeholder: String, buttonTitle: String, buttonAction: @escaping () -> Void) {
        textView.placeholder = placeholder
        gradientButton.setTitle(buttonTitle, for: .normal)
        gradientButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.buttonAction = buttonAction
    }

    // MARK: - Button Action
    private var buttonAction: (() -> Void)?
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    func getText() -> String? {
        return textView.text
    }

    func setText(_ text: String) {
        textView.text = text
        textView.textViewDidChange(textView) // Update placeholder visibility
    }

}

class DottedPatternView: UIView {
    private let dotSize: CGFloat = 2
    private let spacing: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Set dot color
        let dotColor = UIColor(named: "main")!.withAlphaComponent(0.1)
        context.setFillColor(dotColor.cgColor)

        // Calculate number of dots needed
        let columns = Int(rect.width / spacing)
        let rows = Int(rect.height / spacing)

        // Draw dots
        for row in 0...rows {
            for column in 0...columns {
                let x = CGFloat(column) * spacing
                let y = CGFloat(row) * spacing

                context.addEllipse(in: CGRect(
                    x: x - (dotSize/2),
                    y: y - (dotSize/2),
                    width: dotSize,
                    height: dotSize
                ))
            }
        }

        context.fillPath()
    }
}

class PlaceholderTextView: UITextView {
    // Add properties for typewriter effect
    private var typingTimer: Timer?
    private var fullPlaceholderText: String = ""
    private var currentCharacterIndex: Int = 0
    private let typingSpeed: TimeInterval = 0.05 // Adjust speed here

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-LightItalic", size: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 56
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = bounds.width - 24
    }

    var placeholder: String = "" {
        didSet {
            // Stop any existing animation
            stopTypewriterAnimation()

            // Store the full text and start animation
            fullPlaceholderText = placeholder
            startTypewriterAnimation()
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .background
        textColor = .white
        tintColor = .white
        font = UIFont(name: "Roboto-LightItalic", size: 16)

        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])

        delegate = self
    }

    // MARK: - Typewriter Animation
    private func startTypewriterAnimation() {
        currentCharacterIndex = 0
        placeholderLabel.text = ""

        // Create and start the timer
        typingTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            if self.currentCharacterIndex < self.fullPlaceholderText.count {
                let index = self.fullPlaceholderText.index(self.fullPlaceholderText.startIndex, offsetBy: self.currentCharacterIndex)
                self.placeholderLabel.text = (self.placeholderLabel.text ?? "") + String(self.fullPlaceholderText[index])
                self.currentCharacterIndex += 1
            } else {
                self.stopTypewriterAnimation()
            }
        }
    }

    private func stopTypewriterAnimation() {
        typingTimer?.invalidate()
        typingTimer = nil
    }

    // Cleanup
    deinit {
        stopTypewriterAnimation()
    }
}
extension PlaceholderTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

