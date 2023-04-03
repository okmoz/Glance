//
//  HeaderView.swift
//  Glance
//
//  Created by Nazarii Zomko on 23.03.2023.
//

import UIKit

class HeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        let titleLabel = UILabel()
        titleLabel.text = "xCurrency"
        titleLabel.font = UIFont(name: "DIN Round Pro", size: 23)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
    }
    
}
