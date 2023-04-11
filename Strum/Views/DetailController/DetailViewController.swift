//
//  DetailViewController.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 28.03.2023.
//

import UIKit

enum Status {
    case add
    case change
}

protocol DetailViewControllerDelegate: AnyObject {
    func changeData(_ data: FlowIndication?, status: Status)
}

class DetailViewController: BaseController {
    
    lazy var dateManager = DateManager()
    
    weak var delegate: DetailViewControllerDelegate?
    
    var indicationFromCell: FlowIndication?
    
    lazy var indicationDataArray: [FlowIndication] = {
        return []
    }()
    
    private let dayMeterLabel: UILabel = {
        let label = UILabel()
        label.text = "День:"
        return label
    }()
    
    private let nightMeterLabel: UILabel = {
        let label = UILabel()
        label.text = "Ночь:"
        return label
    }()
    
    let dayMeterTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        return textField
    }()
    
    let nightMeterTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата считывания:"
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.contentHorizontalAlignment = .left
        datePicker.maximumDate = .now
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setIndicationDataValue()
    }
    
}

extension DetailViewController {
    
    override func addView() {
        super.addView()
        view.putOnView(stackView)
        stackView.addArrangedSubview(dayMeterLabel)
        stackView.addArrangedSubview(dayMeterTextField)
        stackView.addArrangedSubview(nightMeterLabel)
        stackView.addArrangedSubview(nightMeterTextField)
        view.putOnView(dateStackView)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(datePicker)
        
    }
    
    override func setupLayout() {
        super.setupLayout()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            
            dateStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            dateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateStackView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveDone))
        dateStackView.isHidden = true
    }
    
    @objc func saveDone() {
        let dayMeter = Int(dayMeterTextField.text ?? "0") ?? indicationFromCell?.dayMeter
        let nightMeter = Int(nightMeterTextField.text ?? "0") ?? indicationFromCell?.nightMeter
        var status = Status.add
        
        if indicationFromCell != nil {
            indicationFromCell?.dayMeter = dayMeter ?? 0
            indicationFromCell?.nightMeter = nightMeter ?? 0
            status = .change
        } else if dateStackView.isHidden == false {
            let choosenData = dateManager.getStringFromData(date: datePicker.date)
            indicationFromCell = FlowIndication(dayMeter: dayMeter ?? 0,
                                            nightMeter: nightMeter ?? 0,
                                            transferDate: choosenData)
        }
        delegate?.changeData(indicationFromCell, status: status)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setIndicationDataValue() {
        guard let indication = indicationFromCell else { return }
        dayMeterTextField.text = "\(indication.dayMeter)"
        nightMeterTextField.text = "\(indication.nightMeter)"
    }
}
