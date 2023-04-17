//
//  CurrencyCell.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static let identifier = "CurrencyCell"
    private(set) var currency: Currency!
    
    private let iconImageView = UIImageView() // FIXME: should I use lazy var?
    private let codeLabel = UILabel()
    private let numberView = UIView()
    private let currencyFullNameLabel = UILabel()
    private let blinkingCursorForNumber = UIView()
    private let blinkingCursorForMathExpression = UIView()
    
    let numberTextField = UITextField()
    let mathExpressionTextField = UITextField()
    
    enum ActiveField {
        case number, mathExpression, none
    }
    
    var activeField: ActiveField = .none {
        didSet {
            switch activeField {
            case .number:
                isMathExpressionCursorVisible = false
                isNumberCursorVisible = true
            case .mathExpression:
                isMathExpressionCursorVisible = true
                isNumberCursorVisible = false
            case .none:
                isMathExpressionCursorVisible = false
                isNumberCursorVisible = false
            }
        }
    }
    
    
    var isNumberCursorVisible: Bool = false {
        didSet {
            blinkingCursorForNumber.isHidden = !isNumberCursorVisible
            blinkingCursorForNumber.showBlinkingAnimation(isNumberCursorVisible)
        }
    }
    
    var isMathExpressionCursorVisible: Bool = false {
        didSet {
            blinkingCursorForMathExpression.isHidden = !isMathExpressionCursorVisible
            blinkingCursorForMathExpression.showBlinkingAnimation(isMathExpressionCursorVisible)
        }
    }
    
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
    
    func getActiveTextField() -> UITextField? {
        switch activeField {
        case .number:
            return numberTextField
        case .mathExpression:
            return mathExpressionTextField
        case .none:
            return nil
        }
    }
    
    
    private func setupViews() {
        backgroundColor = UIColor(named: "CurrencyBG")
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.borderWidth = 0.5
        iconImageView.backgroundColor = .systemGray.withAlphaComponent(0.05)
        iconImageView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.2).cgColor
        iconImageView.layer.cornerRadius = 2
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleToFill
        
        contentView.addSubview(codeLabel)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.font = UIFont(name: "DIN Round Pro", size: 17)
        codeLabel.sizeToFit()
        
        contentView.addSubview(numberView) // TODO: Do I need this view?
        numberView.translatesAutoresizingMaskIntoConstraints = false
        
        numberView.addSubview(numberTextField)
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [.foregroundColor: UIColor.label.withAlphaComponent(0.4)])
        numberTextField.textAlignment = .right
        numberTextField.isUserInteractionEnabled = false
        mathExpressionTextField.isUserInteractionEnabled = false
//        numberTextField.isUserInteractionEnabled = false
//        numberTextField.adjustsFontSizeToFitWidth = true
//        numberTextField.minimumFontSize = 15
        numberTextField.font = UIFont(name: "DIN Round Pro", size: 23)
        
        addSubview(mathExpressionTextField)
        mathExpressionTextField.translatesAutoresizingMaskIntoConstraints = false
        mathExpressionTextField.font = UIFont(name: "DIN Round Pro", size: 11)
        mathExpressionTextField.textAlignment = .right
        mathExpressionTextField.layer.opacity = 0.4
//        mathExpressionTextField.backgroundColor = .green
        
        
        addSubview(blinkingCursorForNumber)
        blinkingCursorForNumber.isHidden = true
        blinkingCursorForNumber.translatesAutoresizingMaskIntoConstraints = false
        blinkingCursorForNumber.backgroundColor = .systemBlue

        addSubview(blinkingCursorForMathExpression)
        blinkingCursorForMathExpression.isHidden = true
        blinkingCursorForMathExpression.translatesAutoresizingMaskIntoConstraints = false
        blinkingCursorForMathExpression.backgroundColor = .systemBlue

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
            codeLabel.widthAnchor.constraint(equalToConstant: 40),
            
            numberView.bottomAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 3),
            numberView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            numberView.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 12),
            
            numberTextField.topAnchor.constraint(equalTo: numberView.topAnchor),
            numberTextField.bottomAnchor.constraint(equalTo: numberView.bottomAnchor),
            numberTextField.leftAnchor.constraint(equalTo: numberView.leftAnchor),
            numberTextField.rightAnchor.constraint(equalTo: numberView.rightAnchor),
            
            mathExpressionTextField.bottomAnchor.constraint(equalTo: numberView.topAnchor),
            mathExpressionTextField.rightAnchor.constraint(equalTo: numberView.rightAnchor),
            mathExpressionTextField.leftAnchor.constraint(equalTo: numberView.leftAnchor),
            
            blinkingCursorForNumber.topAnchor.constraint(equalTo: numberView.topAnchor, constant: 3),
            blinkingCursorForNumber.bottomAnchor.constraint(equalTo: numberView.bottomAnchor, constant: -2),
            blinkingCursorForNumber.rightAnchor.constraint(equalTo: numberView.rightAnchor, constant: 2),
            blinkingCursorForNumber.widthAnchor.constraint(equalToConstant: 2),
            
            blinkingCursorForMathExpression.topAnchor.constraint(equalTo: mathExpressionTextField.topAnchor, constant: 1),
            blinkingCursorForMathExpression.bottomAnchor.constraint(equalTo: mathExpressionTextField.bottomAnchor, constant: -1),
            blinkingCursorForMathExpression.rightAnchor.constraint(equalTo: mathExpressionTextField.rightAnchor, constant: 2),
            blinkingCursorForMathExpression.widthAnchor.constraint(equalToConstant: 2),
            
            currencyFullNameLabel.topAnchor.constraint(equalTo: numberView.bottomAnchor),
            currencyFullNameLabel.rightAnchor.constraint(equalTo: numberView.rightAnchor),
        ])
    }
    
}

extension UIView {
    func showBlinkingAnimation(_ showBlinkingAnimation: Bool) {
        if showBlinkingAnimation {
            self.layer.addBlinkingAnimation()
        } else {
            self.layer.removeAllAnimations()
        }
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
