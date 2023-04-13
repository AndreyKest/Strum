//
//  DataManager.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 25.03.2023.
//

import UIKit

class DataManager {
    
    private let userDefaults = UserDefaults.standard
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    lazy var dateFormatter = DateFormatter()
    
    func obtainData() -> [FlowIndication] {
        guard let data = userDefaults.object(forKey: R.UserDefaultsKeys.flowIndicationKey) as? Data else { return [] }
        guard let parsData = try? decoder.decode([FlowIndication].self, from: data) else { return [] }
        let newData = sortedDataArray(parsData)
        return newData
    }
    
    func saveData(_ data: [FlowIndication]) {
        guard let jsonData = try? encoder.encode(data) else { return }
        userDefaults.set(jsonData, forKey: R.UserDefaultsKeys.flowIndicationKey)
    }
    
    func sortedDataArray(_ data: [FlowIndication]) -> [FlowIndication] {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let sortData = data.sorted { firstValue, secondValue in
            guard let date1 = dateFormatter.date(from: firstValue.transferDate),
                  let date2 = dateFormatter.date(from: secondValue.transferDate) else {
                    return false
                }
                return date1 > date2
        }
        return sortData
    }
}
