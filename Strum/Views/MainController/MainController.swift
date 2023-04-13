//
//  MainController.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 24.03.2023.
//

import UIKit

class MainController: BaseController {
    
    //MARK: - constants, variables
    let tableView = MainTableView()
    var indicationData: [FlowIndication] = []
    var rowInSection: Int = 0
    
    //MARK: - Services
    let yearAnalysis = YearsAnalysis()
    let dateManager = DateManager()
    let saveManager = DataManager()
    
    //MARK: - Lazy var
    lazy var yearsArray: [String] = {
        let array = yearAnalysis.obtainYears(in: indicationData)
        return array
    }()
    
    lazy var currentYear: String = {
        let year = dateManager.currentYear()
        return year
    }()
    
    lazy var currentMonth: Int = {
        let month = dateManager.countCurrentMonth()
        return month
    }()
    
    //MARK: - ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //indicationData.append(FlowIndication(dayMeter: 100, nightMeter: 50, transferDate: "01/11/2022"))
        //indicationData.append(FlowIndication(dayMeter: 200, nightMeter: 100, transferDate: "01/02/2023"))
        
        //indicationData = saveManager.obtainData()
        //saveManager.saveData(indicationData)
        indicationData = saveManager.obtainData()
        indicationData.forEach { data in
            print(data.transferDate)
        }
    }
    
}

//MARK: - Extension Settings
extension MainController {
    
    override func addView() {
        super.addView()
        view.putOnView(tableView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = R.Colors.background
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(addIndication))
    }
    
    @objc func addIndication() {
        let detailVC = DetailViewController()
        
        detailVC.delegate = self
        detailVC.dateStackView.isUserInteractionEnabled = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getCurrentIndication(indexPath: IndexPath, rowCount: Int) -> FlowIndication? {
        var indication: FlowIndication?
        indicationData.forEach {
            if dateManager.yearFromDate($0.transferDate) == yearsArray[indexPath.section] && dateManager.monthFromDate($0.transferDate) == "\(rowCount+1-indexPath.row)" {
                indication = FlowIndication(dayMeter: $0.dayMeter, nightMeter: $0.nightMeter, transferDate: $0.transferDate)
            }
        }
        return indication
    }
}


//MARK: - TableViewDataSource, TableViewDelegate
extension MainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentYear == yearsArray[section] {
            rowInSection = currentMonth
            return rowInSection
        } else {
            rowInSection = 12
            return rowInSection
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        yearsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(yearsArray[section])"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let monthes = R.Month.allCases
        let rowCountForCurrentSection = tableView.numberOfRows(inSection: indexPath.section)-1
        let indication = getCurrentIndication(indexPath: indexPath, rowCount: rowCountForCurrentSection)
        
        if let indication = indication {
            cell.dayMeterDataLabel.text = "\(indication.dayMeter)"
            cell.nightMeterDataLabel.text = "\(indication.nightMeter)"
            cell.monthLabel.textColor = .black
            if let nextIndication = yearAnalysis.nextDate(after: indication, in: indicationData) {
                let price = ((indication.dayMeter - nextIndication.dayMeter) * 1.68) + ((indication.nightMeter - nextIndication.nightMeter) * 0.9)
                cell.monthDifferenceCount.text = "\(price)"
            }
        }
        
        cell.monthLabel.text = monthes[rowCountForCurrentSection-indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        detailVC.delegate = self
        tableView.deselectRow(at: indexPath, animated: true)
        
        let rowCountForCurrentSection = tableView.numberOfRows(inSection: indexPath.section)-1
        let indication = getCurrentIndication(indexPath: indexPath, rowCount: rowCountForCurrentSection)
        
        detailVC.indicationFromCell = indication
        
        if indication == nil {
            detailVC.dateStackView.isHidden = true
        } else {
            detailVC.datePicker.date = dateManager.stringToDate(indication!.transferDate)
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: = Change indication on DetailVC

extension MainController: DetailViewControllerDelegate {
    
    private enum ChangeStatus {
        case succes
        case fail
    }
    
    private func saveAndReload(_ data: [FlowIndication]) {
        saveManager.saveData(data)
        tableView.reloadData()
        indicationData.forEach { data in
            print(data.transferDate)
        }
    }
    
    func changeData(_ data: FlowIndication?, status: Status) {
        guard let indication = data else { return }
        switch status {
        case .change:
            if change(indication) == .fail {
                break
            }
        case .add:
            if change(indication) == .succes {
                break
            } else {
                guard let data = data else { break }
                indicationData.append(data)
                indicationData = saveManager.sortedDataArray(indicationData)
                yearsArray = yearAnalysis.obtainYears(in: indicationData)
                saveAndReload(indicationData)
            }
        case .delete:
            guard let data = data else { break }
            indicationData.removeAll(where: { $0 == data })
            yearsArray = yearAnalysis.obtainYears(in: indicationData)
            saveAndReload(indicationData)
        }
    }
    
    private func change(_ data: FlowIndication) -> ChangeStatus {
        if let indiactionValue = indicationData.enumerated().first(where: { dateManager.monthFromDate($0.element.transferDate) == dateManager.monthFromDate(data.transferDate) && dateManager.yearFromDate($0.element.transferDate) == dateManager.yearFromDate(data.transferDate) }) {
            
            indicationData.remove(at: indiactionValue.offset)
            indicationData.insert(data, at: indiactionValue.offset)
            
            indicationData = saveManager.sortedDataArray(indicationData)
            saveAndReload(indicationData)
            
            return .succes
        }
        return .fail
    }
}


//MARK: - Swipe delete data extension
extension MainController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rowCountForCurrentSection = tableView.numberOfRows(inSection: indexPath.section)-1
        guard let indication = getCurrentIndication(indexPath: indexPath, rowCount: rowCountForCurrentSection) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            self.deleteAlert(indication: indication)
            handler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func deleteAlert(indication: FlowIndication) {
        let alert = UIAlertController(title: "Hello", message: "Allert was shown", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            print("Delete")
            self.changeData(indication, status: .delete)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
}
