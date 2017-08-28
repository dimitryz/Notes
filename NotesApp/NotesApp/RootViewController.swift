//
//  RootViewController.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        pushViewController(NotesViewController(), animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
