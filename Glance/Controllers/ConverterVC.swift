//
//  ConverterVC.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import MathExpression
import UIKit

class ConverterVC: UIViewController {
    var tableView = UITableView()
    var numpadView = NumpadView()
    var headerView = HeaderView()
    var selectedCell: CurrencyCell?
    var lastCellWithActiveMathExpressionField: CurrencyCell?
    
    var currencies = [Currency]()
    var currencyRatesWithDate = Constants.defaultCurrencyRatesWithDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNumpadView()
        configureHeaderView()
        configureTableView()
        setSixDefaultCurrencies()
        updateRatesForCurrencies()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectFirstCell()
        Task {
            await loadCurrencyRatesWithDate()
            updateRatesForCurrencies()
            selectFirstCell()
        }
    }
    
    
    // FIXME: put in a model?
    func loadCurrencyRatesWithDate() async {
        if let currencyRatesFromAPI = try? await NetworkManager.shared.fetchCurrencyRatesWithDate(){
            currencyRatesWithDate = currencyRatesFromAPI
            do {
                try PersistenceManager.save(currencyRatesWithDate: currencyRatesFromAPI)
            } catch {
                print(error)
            }
        } else {
            do {
                let currencyRatesFromPersistentStorage = try PersistenceManager.loadCurrencyRatesWithDate()
                currencyRatesWithDate = currencyRatesFromPersistentStorage
            } catch {
                print(error)
            }
        }
    }
    
    func updateRatesForCurrencies() {
        currencies = currencies.map { currency in
            guard let newRate = currencyRatesWithDate.currencyRates[currency.code] else {
                print("Error: Missing currency rate for \(currency.code.uppercased())")
                return currency
            }
            return Currency(code: currency.code, name: currency.name, symbol: currency.symbol, rate: newRate)
        }
        tableView.reloadData()
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
            numpadView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.352), // 0.307 / 0.3078 / 0.3481 / 0.352
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
        return indexPathsForVisibleRows.compactMap { tableView.cellForRow(at: $0) as? CurrencyCell }
    }
    
    
    func selectFirstCell() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        guard let firstCell = getVisibleCells().first else { return }
        selectedCell = firstCell // Although, selectedCell is set every time tableView's didSelectRowAt delegate method is called, I have to set this here because didSelectRowAt doesn't get called when I select a row programmatically (using tableView.selectRow or setSelected methods)
        updatePlaceholderInAllCells()
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let switchCurrencyAction = UIContextualAction(style: .normal, title: "Switch Currency") { [weak self] _,_,completion in
            let currencyListVC = CurrencyPickerVC(indexPathOfCurrencyToReplace: indexPath, currentlyDisplayedCurrencies: self?.currencies ?? [])
            currencyListVC.delegate = self
            self?.navigationController?.present(UINavigationController(rootViewController: currencyListVC), animated: true)
            completion(true)
        }
        switchCurrencyAction.image =  UIImage(systemName: "arrow.left.arrow.right")
        switchCurrencyAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [switchCurrencyAction])
    }
    
    
    func updatePlaceholderInAllCells() {
        guard let selectedCell else { return }
        
        for cell in getVisibleCells() {
            let convertedAmount: Double
            if cell == selectedCell {
                convertedAmount = 100
            } else {
                convertedAmount = selectedCell.currency.rate == 0 ? 0 : (100 / selectedCell.currency.rate) * cell.currency.rate // to avoid division by 0 if currency rate is 0
            }
            cell.numberTextField.placeholderNumber = String(convertedAmount)
        }
    }
    
    
    func updateNumberTextFieldInAllCells() {
        guard let selectedCell else { return }
        let textFieldNumber = selectedCell.numberTextField.number
        
        if textFieldNumber == "" {
            getVisibleCells().forEach { $0.numberTextField.number = "" }
            return
        }
        
        // FIXME: could be optimized by moving 'guard let textFieldNumberAsDouble = Double(textFieldNumber)...' here
        
        for cell in getVisibleCells() {
            let convertedAmount: String
            
            if cell == selectedCell {
                convertedAmount = textFieldNumber
            } else {
                guard let textFieldNumberAsDouble = Double(textFieldNumber) else {
                    print("Could not convert \(textFieldNumber) to Double")
                    continue
                }
                // FIXME: what if rate == 0?
                let amount = (textFieldNumberAsDouble / selectedCell.currency.rate) * cell.currency.rate // FIXME: rename?
                convertedAmount = String(amount)
            }
            
            cell.numberTextField.number = convertedAmount
        }
    }
}

extension ConverterVC: NumpadViewDelegate {
    
    func didTapButton(_ button: UIButton) {
        guard let buttonText = button.titleLabel?.text else { return }

        switch buttonText {
        case "DEL":
            handleDeletePress()
        case ".":
            handleDotPress()
        case "+", "-", "×", "÷":
            handleSymbolPress(symbol: buttonText)
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            handleNumberPress(number: buttonText)
        default:
            break
        }
        
        clearMathExpressionTextFieldIfNeeded()
        setActiveFieldForSelectedCell()
        calculateMathExpressionForSelectedCell()
        updateNumberTextFieldInAllCells()
    }
    
    func clearMathExpressionTextFieldIfNeeded() {
        if lastCellWithActiveMathExpressionField?.currency.code != selectedCell?.currency.code {
            lastCellWithActiveMathExpressionField?.mathExpressionTextField.number = ""
        }
    }
    
    func setActiveFieldForSelectedCell() {
        guard let selectedCell else { return }
        
        if !selectedCell.mathExpressionTextField.number.isEmpty {
            if selectedCell.mathExpressionTextField.number.containsMathSign() {
                selectedCell.activeField = .mathExpression
                lastCellWithActiveMathExpressionField = selectedCell
            } else {
                selectedCell.mathExpressionTextField.number = "" // removes text from mathTF if it doesn't contain a math symbol
                selectedCell.activeField = .number
            }
        } else {
            selectedCell.activeField = .number
        }
    }
    
    func calculateMathExpressionForSelectedCell() {
        guard let selectedCell else { return }
        guard !selectedCell.mathExpressionTextField.number.isEmpty else { return }
        
        do {
            let calculation = try calculate(using: selectedCell.mathExpressionTextField.number.convertingToValidMathExpression())
            selectedCell.numberTextField.number = String(calculation)
        } catch {
            print(error)
        }
    }
    
    func handleDeletePress() {
        guard let activeTextField = selectedCell?.getActiveTextField() else { return }
        if !activeTextField.number.isEmpty {
            activeTextField.number = String(activeTextField.number.dropLast())
        } else {
            activeTextField.shake()
        }
    }
    
    func handleDotPress() {
        guard let activeTextField = selectedCell?.getActiveTextField() else { return }
        
        let lastNumber = getLastNumber(from: activeTextField.number)
        if lastNumber == "" {
            activeTextField.number += "0."
        } else if lastNumber.contains(".") {
            return
        } else {
            activeTextField.number += "."
        }
    }
    
    func handleSymbolPress(symbol: String) {
        guard let selectedCell else { return }
        
        let mathExpression = selectedCell.mathExpressionTextField.number
        if !mathExpression.isEmpty {
            if mathExpression.isLastCharacterMathSign() {
                selectedCell.mathExpressionTextField.number = mathExpression.replacingLastCharacter(with: symbol)
            } else {
                selectedCell.mathExpressionTextField.number.append(symbol)
            }
        } else {
            if !selectedCell.numberTextField.number.isEmpty {
                selectedCell.mathExpressionTextField.number.append(selectedCell.numberTextField.number + symbol)
            } else {
                selectedCell.mathExpressionTextField.number.append("0.0" + symbol)
            }
        }
    }
    
    func handleNumberPress(number: String) {
        guard let activeTextField = selectedCell?.getActiveTextField() else { return }
        if let decimalPlaces = Decimal(string: activeTextField.number) {
            guard decimalPlaces.significantFractionalDecimalDigits < 8 else { // checks if number of fractional digits is < 8
                activeTextField.shake()
                return
            }
        }

        if activeTextField.number == "0" && number == "0" {
            return
        } else if activeTextField.number == "0" && number != "0" {
            activeTextField.number = number // if TF number is "0" and pressed number is "3", it will replace "0" with "3"
        } else {
            activeTextField.number += number
        }
    }
    
    func calculate(using text: String) throws -> Double { // move to a separate model?
        let mathString = text.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/") // MathExpression class accepts only "*" and "/"
        let expression = try MathExpression(mathString)
        return expression.evaluate()
    }
    
    func getLastNumber(from text: String) -> String {
        let numbers = text.components(separatedBy: CharacterSet(charactersIn: Constants.mathSigns.joined()))
        return numbers.last ?? ""
    }
}


extension ConverterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencies[indexPath.row]
        return CurrencyCell(currency: currency, reuseIdentifier: CurrencyCell.identifier) // I don't use dequeueReusableCell here on purpose; 3 reasons: 1) I don't need performance benefits, 2) I want tableView to create new cells each time, 3) I can use a custom init to pass currency and not having it implicitly unwrapped inside CurrencyCell
    }
}


extension ConverterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = (tableView.cellForRow(at: indexPath) as! CurrencyCell)
        updatePlaceholderInAllCells()
        DispatchQueue.main.async { // this adds animation for cell height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selectedCellHeight = (tableView.frame.size.height / CGFloat(currencies.count) * 1.2)
        let normalCellHeight = (tableView.frame.size.height - selectedCellHeight) / CGFloat(currencies.count - 1)
        return indexPath == tableView.indexPathForSelectedRow ? selectedCellHeight : normalCellHeight
    }
}


extension ConverterVC: CurrencyListVCDelegate {
    func didPickCurrency(_ currency: Currency, indexPathOfCurrencyToReplace: IndexPath) {
        currencies[indexPathOfCurrencyToReplace.row] = currency
        updateRatesForCurrencies()
        selectFirstCell()
    }
}
