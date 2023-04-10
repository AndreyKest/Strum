//
//  YearsAnalysis.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 26.03.2023.
//

import Foundation

class YearsAnalysis {
    
    func obtainYears(in data: [FlowIndication]) -> [String] {
        var resultArray: [String] = []
        for value in data {
            guard let year = value.transferDate.components(separatedBy: "/").last else { continue }
            resultArray.append(year)
        }
        resultArray = resultArray.sorted(by: { $0 > $1 })
        return resultArray
    }
}
