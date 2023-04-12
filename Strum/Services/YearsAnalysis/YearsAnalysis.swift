//
//  YearsAnalysis.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 26.03.2023.
//

import Foundation

class YearsAnalysis {
    
    func obtainYears(in data: [FlowIndication]) -> [String] {
        var uniqueYears: Set<String> = []
        for value in data {
            guard let year = value.transferDate.components(separatedBy: "/").last else { continue }
            uniqueYears.insert(year)
        }
        let sortedYears = uniqueYears.sorted(by: >)
        return sortedYears
    }
}
