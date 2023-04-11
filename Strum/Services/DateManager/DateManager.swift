//
//  DateManager.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 26.03.2023.
//

import Foundation

class DateManager {
    
    private lazy var dateFormatter = DateFormatter()
    private lazy var currentDate = Date()
    
    func getCurrentDate() -> String {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    func getStringFromData(date: Date) -> String {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func countCurrentMonth() -> Int {
        dateFormatter.dateFormat = "MM"
        let dateString = dateFormatter.string(from: currentDate)
        guard let month = Int(dateString) else { return 12 }
        return month
        
    }
    
    func currentYear() -> String {
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
        
    }
    
    func yearFromDate(_ date: String) -> String {
        guard let year = date.components(separatedBy: "/").last else { return "" }
        return year
    }
    
    func monthFromDate(_ date: String) -> String {
        let components = date.components(separatedBy: "/")
        if components.count >= 2, let month = Int(components[1]) {
            return "\(month)"
        }
        return ""
    }
    
    func stringToDate(_ stringDate: String) -> Date {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let resultDate = dateFormatter.date(from: stringDate) else { return currentDate }
        return resultDate
    }
}
