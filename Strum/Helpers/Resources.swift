//
//  Resources.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 24.03.2023.
//

import UIKit

enum R {
    
    enum Colors {
        static let active = UIColor(hexString: "#437BFE")
        static let inactive = UIColor(hexString: "#929DA5")
        
        static let background = UIColor(hexString: "#F8F9F9")
        static let separator = UIColor(hexString: "#E8ECEF")
        static let secondary = UIColor(hexString: "#F0F3FF")
        
        
        static let titleGray = UIColor(hexString: "#545C77")
    }
    
    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .mainview:
                    return "Main"
                case .addview:
                    return "Statistic"
                case .settings:
                    return "Settings"
                }
            }
        }
    }
    
    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .mainview:
                    return UIImage(named: "main_tab")
                case .addview:
                    return  UIImage(named: "add_tab")
                case .settings:
                    return UIImage(named: "settings_tab")
                }
            }
        }
        
    }
    
    enum Month: String, CaseIterable {
        case january = "Январь"
        case february = "Февраль"
        case march = "Март"
        case april = "Апрель"
        case may = "Май"
        case june = "Июнь"
        case july = "Июль"
        case august = "Август"
        case september = "Сентябрь"
        case october = "Октябрь"
        case november = "Ноябрь"
        case december = "Декабрь"
    }
    
    enum UserDefaultsKeys {
        static let flowIndicationKey = "flowIndicationKey"
    }
}
