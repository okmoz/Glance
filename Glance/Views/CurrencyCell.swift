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
    let numberTextField = GLTextField()
    let mathExpressionTextField = GLTextField()

    enum ActiveField {
        case number, mathExpression, none
    }
    
    var activeField: ActiveField = .none {
        didSet {
            switch activeField {
            case .number:
                isMathExpressionCursorVisible = false // FIXME: make it a property on GLTextField
                isNumberCursorVisible = true
                mathExpressionTextField.isOnSelectedCell = true
                numberTextField.isOnSelectedCell = true
            case .mathExpression:
                isMathExpressionCursorVisible = true
                isNumberCursorVisible = false
                mathExpressionTextField.isOnSelectedCell = true
                numberTextField.isOnSelectedCell = true
            case .none:
                isMathExpressionCursorVisible = false
                isNumberCursorVisible = false
                mathExpressionTextField.isOnSelectedCell = false
                numberTextField.isOnSelectedCell = false
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if let mathExpressionTextFieldText = mathExpressionTextField.text, !mathExpressionTextFieldText.isEmpty {
                activeField = .mathExpression
            } else {
                activeField = .number
            }
            mathExpressionTextField.isHidden = false
            backgroundColor = UIColor(named: "SelectedCurrencyColor")
        } else {
            activeField = .none
            mathExpressionTextField.isHidden = true
            backgroundColor = UIColor(named: "CurrencyBG")
        }
    }
    
    
    private var isNumberCursorVisible: Bool = false {
        didSet {
            blinkingCursorForNumber.isHidden = !isNumberCursorVisible
            blinkingCursorForNumber.showBlinkingAnimation(isNumberCursorVisible)
        }
    }
    
    private var isMathExpressionCursorVisible: Bool = false {
        didSet {
            blinkingCursorForMathExpression.isHidden = !isMathExpressionCursorVisible
            blinkingCursorForMathExpression.showBlinkingAnimation(isMathExpressionCursorVisible)
        }
    }
    
    
    init(currency: Currency, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        configure(with: currency)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(with currency: Currency) {
        self.currency = currency
        iconImageView.image = currency.icon
        codeLabel.text = currency.code.uppercased()
        currencyFullNameLabel.text = "\(currency.name) \(currency.symbol)"
    }
    
    func getActiveTextField() -> GLTextField? {
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
//        numberTextField.adjustsFontSizeToFitWidth = true
//        numberTextField.minimumFontSize = 15
        numberTextField.font = UIFont(name: "DIN Round Pro", size: 23)
        
        addSubview(mathExpressionTextField)
        mathExpressionTextField.translatesAutoresizingMaskIntoConstraints = false
        mathExpressionTextField.font = UIFont(name: "DIN Round Pro", size: 11)
        mathExpressionTextField.textAlignment = .right
        mathExpressionTextField.isUserInteractionEnabled = false
        
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
        
        let iconImageViewHeight = UIScreen.main.bounds.height / 28
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: iconImageViewHeight),
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
    
    @objc func textFieldDidChange() {
        print("didChange")
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
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
//        animation.values = [0.0, -3.0, 4.0, -4.0, 4.0, -3.0, 0.0]
        animation.values = [-3.0, 3.0, -3.0, 3.0, -3.0, 0.0]
        layer.add(animation, forKey: "shake")
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
