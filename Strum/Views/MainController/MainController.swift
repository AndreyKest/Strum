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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(saveDone))
    }
    
    @objc func saveDone() {
        let detailVC = DetailViewController()
        
        detailVC.delegate = self
        detailVC.dateStackView.isHidden = false
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
        
        detailVC.indicationData = indication
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension MainController: DetailViewControllerDelegate {
    func changeData(_ data: FlowIndication?, status: Status) {
        guard let indication = data else { return }
        switch status {
        case .change:
            if let indiactionValue = indicationData.enumerated().first(where: { $0.element.transferDate == indication.transferDate }) {
                
                indicationData.remove(at: indiactionValue.offset)
                indicationData.insert(indication, at: indiactionValue.offset)
                
                saveManager.saveData(indicationData)
                
                tableView.reloadData()
            }
        case .add:
            if let data = data {
                indicationData.append(data)
                saveManager.saveData(indicationData)
                tableView.reloadData()
            }
            
        }
    }
}

