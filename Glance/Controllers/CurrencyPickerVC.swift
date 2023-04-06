//
//  CurrencyPickerVC.swift
//  Glance
//
//  Created by Nazarii Zomko on 29.03.2023.
//

import UIKit


class CurrencyPickerVC: UIViewController {
    var tableView: UITableView!
    var indexPathOfCurrencyToReplace: IndexPath
    var currentlyDisplayedCurrencies: [Currency] // this will enable me to show checkmarks for currencies that are displayed in ConverterVC
    
    weak var delegate: CurrencyListVCDelegate?
    
    init(indexPathOfCurrencyToReplace: IndexPath, currentlyDisplayedCurrencies: [Currency], delegate: CurrencyListVCDelegate? = nil) {
        self.indexPathOfCurrencyToReplace = indexPathOfCurrencyToReplace
        self.currentlyDisplayedCurrencies = currentlyDisplayedCurrencies
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Switch Currency"
        configureTableView()
    }
    
    var currencies = Constants.currencies
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds) // how to not clip last elements of the table view?
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
    }
}


extension CurrencyPickerVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currency = currencies[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.imageProperties.maximumSize = CGSize(width: 25, height: 25)
        config.imageProperties.cornerRadius = 1
        config.image = currency.icon

        if currentlyDisplayedCurrencies.contains(where: { $0.code == currency.code }) {
            let checkmark = UIImageView(image: UIImage(named: "check"))
            checkmark.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }
//        cell.accessoryType = currentlyDisplayedCurrencies.contains(currency) ? .checkmark : .none


        let currencyAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "DIN Round Pro", size: 16) ?? UIFont()
        ]

        let currencyCodeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label.withAlphaComponent(0.3),
            .font: UIFont(name: "DIN Round Pro", size: 16) ?? UIFont()
        ]

        let attributedString = NSMutableAttributedString(string: currency.name, attributes: currencyAttributes)
        attributedString.append(NSAttributedString(string: "  \(currency.code.uppercased())", attributes: currencyCodeAttributes))

        config.attributedText = attributedString

        cell.contentConfiguration = config
        return cell
    }
    
}


extension CurrencyPickerVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        delegate?.didPickCurrency(currency, indexPathOfCurrencyToReplace: indexPathOfCurrencyToReplace)
        dismiss(animated: true)
    }

}


// MARK: CurrencyListVCDelegate
protocol CurrencyListVCDelegate: AnyObject {
    func didPickCurrency(_ currency: Currency, indexPathOfCurrencyToReplace: IndexPath?)
}
