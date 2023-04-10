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
    
    func obtainData() -> [FlowIndication] {
        guard let data = userDefaults.object(forKey: R.UserDefaultsKeys.flowIndicationKey) as? Data else { return [] }
        guard let parsData = try? decoder.decode([FlowIndication].self, from: data) else { return [] }
        
        return parsData
    }
    
    func saveData(_ data: [FlowIndication]) {
        
        guard let jsonData = try? encoder.encode(data) else { return }
        userDefaults.set(jsonData, forKey: R.UserDefaultsKeys.flowIndicationKey)
    }
    
    
}
