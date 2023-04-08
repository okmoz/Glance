//
//  NumpadView.swift
//  Glance
//
//  Created by Nazarii Zomko on 17.03.2023.
//

import UIKit

class NumpadView: UIView {
    var buttons = [UIButton]()
    
    weak var delegate: NumpadViewDelegate?
    
    // no init is required here because the buttons are layed out with a frame instead of constraints and in order the calculate their frames we depend on the frame of the NumpadView. And its frame becomes available only after setting constraints in CurrencyListVC. Only after the constraints are set and NumpadView's frame is updated with layoutIfNeeded() method, the setupViews() method is called
    
    public func setupViews() {
        let numpadBGView = UIView()
        numpadBGView.backgroundColor = UIColor(named: "NumpadBGColor")
        numpadBGView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numpadBGView)
        
        NSLayoutConstraint.activate([
            numpadBGView.topAnchor.constraint(equalTo: topAnchor),
            numpadBGView.bottomAnchor.constraint(equalTo: superview?.bottomAnchor ?? bottomAnchor),
            numpadBGView.leftAnchor.constraint(equalTo: leftAnchor),
            numpadBGView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        let buttonTitles = ["7", "8", "9", "+", "4", "5", "6", "-", "1", "2", "3", "×", ".", "0", "DEL", "÷"]
        let buttonSize = CGSize(width: frame.width / 4, height: frame.height / 4)
        
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            var config = UIButton.Configuration.filled()
            config.baseForegroundColor = UIColor(named: "NumpadButtonTitleColor")
            
            var attrTitle = AttributedString(title)
            let mathSigns = ["+", "-", "×", "÷"]
            var titleFont = mathSigns.contains(title) ? UIFont(name: "Roboto Mono", size: 32) : UIFont(name: "DIN Round Pro", size: 23)
            if title == "-" { titleFont = UIFont(name: "Roboto Mono", size: 40) }
            attrTitle.font = titleFont
            config.attributedTitle = attrTitle
            
            let configurationUpdateHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .highlighted:
                    button.configuration?.baseBackgroundColor = .white.withAlphaComponent(0.1)
                default:
                    button.configuration?.baseBackgroundColor = .clear
                }
            }
            
            button.configurationUpdateHandler = configurationUpdateHandler
            button.configuration = config
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
            
            if title == "DEL" {
                button.setImage(UIImage(systemName: "delete.left"), for: .normal)
                button.setTitle("", for: .normal)
            }
            
            let row = index / 4
            let col = index % 4
            
            button.frame = CGRect(x: CGFloat(col) * buttonSize.width, y: CGFloat(row) * buttonSize.height, width: buttonSize.width, height: buttonSize.height)
            
            addSubview(button)
            buttons.append(button)
        }
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .white
        separatorLine.layer.opacity = 0.05
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            separatorLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -buttonSize.width),
            separatorLine.topAnchor.constraint(equalTo: topAnchor, constant: 37),
            separatorLine.bottomAnchor.constraint(equalTo: superview?.bottomAnchor ?? bottomAnchor, constant: -37),
            separatorLine.widthAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    
    @objc private func handleButtonPress(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }
    
}


// MARK: NumpadViewDelegate
protocol NumpadViewDelegate: AnyObject {
    func didTapButton(_ button: UIButton)
}
