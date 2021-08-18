//
//  RoundedButton.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

class RoundedButton: UIButton {
    
    static let defaultInsets: UIEdgeInsets = .init(top: 4, left: 12, bottom: 4, right: 12)
    
    enum Style {
        case solidWhite
        case solidTint
        case line
        case lineGray
        case lineWhite
        case lineSemiTint
    }
        
    private(set) lazy var textLabel: UILabel = {
        let textLabel = UILabel.default()
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .semibold)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.isUserInteractionEnabled = false
        textLabel.textAlignment = .center
        textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        textLabel.setContentHuggingPriority(.required, for: .vertical)
        return textLabel
    }()
    
    var style: Style {
        didSet {
            self.applyStyle()
        }
    }
    
    var title: String {
        didSet {
            self.textLabel.text = title
        }
    }
    
    var fontSize: CGFloat = 14 {
        didSet {
            self.textLabel.font = self.textLabel.font.withSize(fontSize)
        }
    }
    
    var insets: UIEdgeInsets = RoundedButton.defaultInsets {
        didSet {
            leadingConstraint.constant = insets.left.magnitude
            trailingConstraint.constant = -(insets.right.magnitude)
            topConstraint.constant = insets.top.magnitude
            bottomConstraint.constant = -(insets.bottom.magnitude)
        }
    }

    init(title: String, style: Style) {
        self.style = style
        self.title = title
        super.init(frame: .zero)
        self.textLabel.text = title
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
    }
    
    private lazy var leadingConstraint: NSLayoutConstraint = textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left.magnitude)
    private lazy var trailingConstraint: NSLayoutConstraint = textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(insets.right.magnitude))
    private lazy var topConstraint: NSLayoutConstraint = textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top.magnitude)
    private lazy var bottomConstraint: NSLayoutConstraint = textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(insets.bottom.magnitude))

    private func configure() {
        self.clipsToBounds = true
        
        self.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            topConstraint,
            bottomConstraint,
        ])
        
        self.applyStyle()
    }
    
    override func tintColorDidChange() {
        self.applyStyle()
        super.tintColorDidChange()
    }
    
    private func applyStyle() {
        switch style {
        case .lineWhite:
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = .clear
            self.textLabel.textColor = UIColor.white
            self.textLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        case .lineGray:
            self.layer.borderColor = UIColor(hexString: "#A0A0A0")?.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = .clear
            self.textLabel.textColor = UIColor(hexString: "#A0A0A0")
            self.textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .regular)
        case .line:
            self.layer.borderColor = self.tintColor?.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = .clear
            self.textLabel.textColor = self.tintColor
            self.textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .regular)
        case .lineSemiTint:
            self.layer.borderColor = self.tintColor?.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = self.tintColor.withAlphaComponent(0.2)
            self.textLabel.textColor = self.tintColor
            self.textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .regular)
        case .solidTint:
            self.layer.borderWidth = 0
            self.backgroundColor = self.tintColor
            self.textLabel.textColor = .white
            self.textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .bold)
        case .solidWhite:
            self.layer.borderWidth = 0
            self.backgroundColor = .white
            self.textLabel.textColor = self.tintColor
            self.textLabel.font = UIFont.customFont(ofSize: fontSize, weight: .medium)
        }
    }
}
