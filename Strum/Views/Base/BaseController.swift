//
//  BaseController.swift
//  Strum
//
//  Created by Kostanovsky Andrey on 24.03.2023.
//

import UIKit

class BaseController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addView()
        setupLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc extension BaseController {
    
    
    func addView() {}
    func setupLayout() {}
    func configureAppearance() {}
}
