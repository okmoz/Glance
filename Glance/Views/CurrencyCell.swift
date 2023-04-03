//
//  CurrencyCell.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static let identifier = "CurrencyCell"
    var currency: Currency! // FIXME: implicitly unwrapped optional
    var amount: Double?
    var iconImageView = UIImageView()
    var codeLabel = UILabel()
    var numberTextField = UITextField()
    var currencyFullNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
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
        
        contentView.addSubview(numberTextField)
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.attributedPlaceholder = NSAttributedString(string: "0.00", attributes: [.foregroundColor: UIColor.label.withAlphaComponent(0.4)])
        numberTextField.textAlignment = .right
        numberTextField.adjustsFontSizeToFitWidth = true
        numberTextField.minimumFontSize = 15
//        numberTextField.isUserInteractionEnabled = false
        numberTextField.font = UIFont(name: "DIN Round Pro", size: 23)
        
        let touchesDisablerView = UIView() // disables touches in numberTextField
        contentView.addSubview(touchesDisablerView)
        touchesDisablerView.translatesAutoresizingMaskIntoConstraints = false
        touchesDisablerView.backgroundColor = .clear
        
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
            
            numberTextField.bottomAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 3),
            numberTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            numberTextField.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 12),
            
            touchesDisablerView.topAnchor.constraint(equalTo: numberTextField.topAnchor),
            touchesDisablerView.bottomAnchor.constraint(equalTo: numberTextField.bottomAnchor),
            touchesDisablerView.leftAnchor.constraint(equalTo: numberTextField.leftAnchor),
            touchesDisablerView.rightAnchor.constraint(equalTo: numberTextField.rightAnchor),
            
            currencyFullNameLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor),
            currencyFullNameLabel.rightAnchor.constraint(equalTo: numberTextField.rightAnchor)
            
        ])
    }
}
