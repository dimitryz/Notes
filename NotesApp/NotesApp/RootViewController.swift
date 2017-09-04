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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loadingView)
        
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Public
    
    func showLoading(callback: (() -> Void)? = nil) {
        loadingView.fadeIn(animated: true, callback: callback)
    }
    
    func hideLoading(callback: (() -> Void)? = nil) {
        loadingView.fadeOut(animated: true, callback: callback)
    }
    
    // MARK: - Private
    
    private let loadingView = LoadingView()
}
