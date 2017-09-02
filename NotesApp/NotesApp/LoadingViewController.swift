//
//  LoadingViewController.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-09-02.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingIndicator.startAnimating()
    }
    
    // MARK: - Private
    
    private let loadingIndicator = UIActivityIndicatorView()
}
