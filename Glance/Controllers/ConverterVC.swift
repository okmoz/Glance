//
//  ConverterVC.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import UIKit

// when switching a currency, update rates

// USE UILABEL INSTEAD OF UITEXTFIELD?
// remove some crypto

class ConverterVC: UIViewController {
    var tableView = UITableView()
    var numpadView = NumpadView()
    var headerView = HeaderView()
    var selectedCell: CurrencyCell? {
        didSet {
            guard selectedCell != oldValue else { return }
            didSelectCell()
        }
    }
    
    var currencies = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNumpadView()
        configureHeaderView()
        configureTableView()
        setSixDefaultCurrencies()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.rowHeight = tableView.frame.size.height / CGFloat(currencies.count)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstCell()
        Task {
            await loadData()
        }
    }
    
    
    func loadData() async {
        do {
            let currencyRates = try await getCurrencyRates()
            try updateCurrencyRates(with: currencyRates)
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    func getCurrencyRates() async throws -> [String: Double] {
        return try await NetworkManager.shared.getAPIResult().currencyRates
    }
    

    func updateCurrencyRates(with currencyRates: [String: Double]) throws {
        guard !getVisibleCells().isEmpty else {
            throw GLError.noVisibleCells
        }
        
        guard !currencyRates.isEmpty else {
            throw GLError.emptyCurrencyRates
        }
        
        for cell in getVisibleCells() {
            let code = cell.currency.code.lowercased()
            guard let rate = currencyRates[code] else {
                print("Error: Missing currency rate for \(code.uppercased())")
                continue
            }
            cell.currency.rate = rate
        }
    }

    
    func configureViewController() {
        view.backgroundColor = UIColor(named: "CurrencyBG")
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func configureNumpadView() {
        numpadView.delegate = self
        numpadView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numpadView)
        
        NSLayoutConstraint.activate([
            numpadView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            numpadView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.307), // 0.307 / 0.3078 / 0.3481 / 0.352
            numpadView.leftAnchor.constraint(equalTo: view.leftAnchor),
            numpadView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        numpadView.layoutIfNeeded() // idk, I was searching for a way to update view's frame after setting contraints and this seemed to work
        numpadView.setupViews()
    }
    
    
    func configureHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: numpadView.topAnchor)
        ])
    }
    
    
    func setSixDefaultCurrencies() {
        let defaultCurrencies = ["jpy", "uah", "usd", "eur", "gbp", "pln"]
        
        for defaultCurrency in defaultCurrencies {
            for currency in Constants.currencies {
                if currency.code == defaultCurrency {
                    currencies.append(currency)
                }
            }
        }
    }
    
    
    func getVisibleCells() -> [CurrencyCell] {
        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else { return [] }
        return indexPathsForVisibleRows.compactMap {
            tableView.cellForRow(at: $0) as? CurrencyCell
        }
    }
    
    
    func selectFirstCell() {
        guard let firstCell = getVisibleCells().first else { return }
        firstCell.setSelected(true, animated: true)
        selectedCell = firstCell // I have to set this manually because didSelectRowAt method doesn't get called when I select a row with tableView.selectRow method
    }
    
    
    func didSelectCell() {
        selectedCell?.numberTextField.becomeFirstResponder()
        updatePlaceholderInAllTextFields()
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let switchCurrencyAction = UIContextualAction(style: .normal, title: "Switch Currency") { [weak self] _,_,completion in
            let currencyListVC = CurrencyListVC()
            currencyListVC.delegate = self
            currencyListVC.indexPathOfCurrencyToReplace = indexPath
            currencyListVC.currentlyDisplayedCurrencies = self?.currencies
            self?.navigationController?.present(UINavigationController(rootViewController: currencyListVC), animated: true)

            completion(true)
        }
        switchCurrencyAction.image =  UIImage(systemName: "arrow.left.arrow.right")
        switchCurrencyAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [switchCurrencyAction])
    }
    
    
    func updatePlaceholderInAllTextFields() {
        guard let selectedCell else { return }

        for cell in getVisibleCells() {
            let convertedAmount: Double
            if cell == selectedCell {
                convertedAmount = 100
            } else {
                convertedAmount = selectedCell.currency.rate == 0 ? 0 : (100 / selectedCell.currency.rate) * cell.currency.rate // to avoid division by 0 if currency rate is 0
            }
            cell.numberTextField.placeholder = String(format: "%.2f", convertedAmount)
        }
    }
    
    
    func updateTextInAllTextFields() {
        guard let selectedCell else { return }
        guard let textFiledText = selectedCell.numberTextField.text else { return }
        
        if textFiledText == "" {
            getVisibleCells().forEach { $0.numberTextField.text = "" }
            return
        }
        
        for cell in getVisibleCells() {
            let convertedAmount: String
            
            if cell == selectedCell {
                convertedAmount = textFiledText
            } else {
                guard let textFiledText = Double(textFiledText) else {
                    print("Could not convert \(textFiledText) to Double")
                    continue
                }
                
                let amount = (textFiledText / selectedCell.currency.rate) * cell.currency.rate
                convertedAmount = String(format: "%.2f", amount)
            }
            
            cell.numberTextField.text = convertedAmount
        }
    }
    
}

extension ConverterVC: NumpadViewDelegate {
    
    func didTapButton(_ button: UIButton) {
        guard let button = button.titleLabel?.text else { return }
        guard let selectedCell else { return }
        
        switch button {
        case "DEL":
            selectedCell.numberTextField.text? = String(selectedCell.numberTextField.text?.dropLast() ?? "")
        case ".":
            guard let numberTextFieldText = selectedCell.numberTextField.text else { return }
            if numberTextFieldText == "" {
                selectedCell.numberTextField.text! = "0."
            } else {
                if !numberTextFieldText.contains(".") {
                    selectedCell.numberTextField.text! += "."
                }
            }
        case "+":
            break
        case "-":
            break
        case "×":
            break
        case "÷":
            break
        default:
            selectedCell.numberTextField.text! += button
        }
        
        updateTextInAllTextFields()
        
        // if operation symbols -> show calculatorTextField above numberTextField and make it the first responder
    }
    
}


extension ConverterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath) as! CurrencyCell
        let currency = currencies[indexPath.row]
        cell.configure(with: currency)
        return cell
    }
    
}


extension ConverterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = (tableView.cellForRow(at: indexPath) as! CurrencyCell)
    }
}


extension ConverterVC: CurrencyListVCDelegate {
    func didPickCurrency(_ currency: Currency, indexPathOfCurrencyToReplace: IndexPath?) {
        guard let indexPathOfCurrencyToReplace else { return }
        currencies[indexPathOfCurrencyToReplace.row] = currency
        tableView.reloadData()
        selectFirstCell()
    }
}
