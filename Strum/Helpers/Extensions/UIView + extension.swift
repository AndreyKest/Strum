//
//  UIView + extension.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 25.03.2023.
//

import UIKit

extension UIView {
    
    func putOnView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
