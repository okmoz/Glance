//
//  CurrencyCell.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static let identifier = "CurrencyCell"
    var currency: Currency!
    
    var number = "" {
        didSet {
            numberLabel.text = number
            placeholderNumberLabel.alpha = number == "" ? 1 : 0
        }
    }
    
    var placeholderNumber = "" {
        didSet {
            placeholderNumberLabel.text = placeholderNumber
        }
    }
    
    var showingCursor = false {
        didSet {
            if showingCursor {
                blinkingCursor.isHidden = false
                blinkingCursor.layer.addBlinkingAnimation()
            } else {
                blinkingCursor.isHidden = true
                blinkingCursor.layer.removeAllAnimations()
            }
            
        }
    }
    
    private let iconImageView = UIImageView() // FIXME: should I use lazy var?
    private let codeLabel = UILabel()
    private let numberView = UIView()
    private let numberLabel = UILabel()
    private let placeholderNumberLabel = UILabel()
    private let blinkingCursor = UIView()
    private let currencyFullNameLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with currency: Currency) {
        self.currency = currency
        iconImageView.image = currency.icon
        codeLabel.text = currency.code.uppercased()
        currencyFullNameLabel.text = "\(currency.name) \(currency.symbol)"
    }
    
    
    private func setupViews() {
        backgroundColor = UIColor(named: "CurrencyBG")
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.borderWidth = 0.5
        iconImageView.backgroundColor = .systemGray
        iconImageView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        iconImageView.layer.cornerRadius = 2
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleToFill
        
        contentView.addSubview(codeLabel)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.font = UIFont(name: "DIN Round Pro", size: 17)
        
        contentView.addSubview(numberView)
        numberView.translatesAutoresizingMaskIntoConstraints = false
        
        numberView.addSubview(placeholderNumberLabel)
        placeholderNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderNumberLabel.textColor = .label.withAlphaComponent(0.4)
        placeholderNumberLabel.textAlignment = .right
        placeholderNumberLabel.adjustsFontSizeToFitWidth = true
        placeholderNumberLabel.minimumScaleFactor = 0.4
        placeholderNumberLabel.font = UIFont(name: "DIN Round Pro", size: 23)
        
        numberView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.textAlignment = .right
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.minimumScaleFactor = 0.4
        numberLabel.font = UIFont(name: "DIN Round Pro", size: 23)
        
        addSubview(blinkingCursor)
        blinkingCursor.translatesAutoresizingMaskIntoConstraints = false
        blinkingCursor.backgroundColor = .systemBlue
        
        contentView.addSubview(currencyFullNameLabel)
        currencyFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyFullNameLabel.textAlignment = .right
        currencyFullNameLabel.font = UIFont(name: "DIN Round Pro", size: 9.5)
        currencyFullNameLabel.layer.opacity = 0.4
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.43),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            codeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            codeLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12),
            
            numberView.bottomAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 3),
            numberView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            numberView.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 12),
            
            placeholderNumberLabel.topAnchor.constraint(equalTo: numberView.topAnchor),
            placeholderNumberLabel.bottomAnchor.constraint(equalTo: numberView.bottomAnchor),
            placeholderNumberLabel.leftAnchor.constraint(equalTo: numberView.leftAnchor),
            placeholderNumberLabel.rightAnchor.constraint(equalTo: numberView.rightAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: numberView.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: numberView.bottomAnchor),
            numberLabel.leftAnchor.constraint(equalTo: numberView.leftAnchor),
            numberLabel.rightAnchor.constraint(equalTo: numberView.rightAnchor),
            
            blinkingCursor.topAnchor.constraint(equalTo: numberView.topAnchor, constant: 3),
            blinkingCursor.bottomAnchor.constraint(equalTo: numberView.bottomAnchor, constant: -2),
            blinkingCursor.rightAnchor.constraint(equalTo: numberView.rightAnchor, constant: 2),
            blinkingCursor.widthAnchor.constraint(equalToConstant: 2),
            
            currencyFullNameLabel.topAnchor.constraint(equalTo: numberView.bottomAnchor),
            currencyFullNameLabel.rightAnchor.constraint(equalTo: numberView.rightAnchor)
        ])
    }
    
}

extension CALayer {
    func addBlinkingAnimation() {
        let key = "opacity"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.54
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        self.add(animation, forKey: key)
    }
}
