//
//  MainTableViewCell.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 25.03.2023.
//

import UIKit


class MainTableViewCell: UITableViewCell {
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private let dayMeterLabel: UILabel = {
        let label = UILabel()
        label.text = "День:"
        label.textColor = .gray
        return label
    }()
    
    private let nightMeterLabel: UILabel = {
        let label = UILabel()
        label.text = "Ночь:"
        label.textColor = .gray
        return label
    }()
    
    let dayMeterDataLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let nightMeterDataLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let monthDifferenceCount: UILabel = {
        let label = UILabel()
        label.textColor = .green
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayMeterDataLabel.text = ""
        nightMeterDataLabel.text = ""
        monthLabel.textColor = .gray
        monthDifferenceCount.text = ""
    }
}

extension MainTableViewCell {
    
    func addView() {
        contentView.putOnView(monthLabel)
        contentView.putOnView(dayMeterLabel)
        contentView.putOnView(nightMeterLabel)
        contentView.putOnView(dayMeterDataLabel)
        contentView.putOnView(nightMeterDataLabel)
        contentView.putOnView(monthDifferenceCount)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            dayMeterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dayMeterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            
            dayMeterDataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dayMeterDataLabel.leadingAnchor.constraint(equalTo: dayMeterLabel.trailingAnchor, constant: 10),
            
            nightMeterLabel.topAnchor.constraint(equalTo: dayMeterLabel.bottomAnchor, constant: 10),
            nightMeterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            nightMeterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            nightMeterDataLabel.topAnchor.constraint(equalTo: dayMeterDataLabel.bottomAnchor, constant: 10),
            nightMeterDataLabel.leadingAnchor.constraint(equalTo: nightMeterLabel.trailingAnchor, constant: 10),
            nightMeterDataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            monthDifferenceCount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            monthDifferenceCount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}
