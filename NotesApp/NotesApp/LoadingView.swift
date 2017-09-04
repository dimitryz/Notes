//
//  LoadingView.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-09-03.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        fadeOut(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func fadeIn(animated: Bool, callback: (() -> Void)? = nil) {
        isHidden = false
        startAnimating()
        
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: { [weak self] in
            self?.layer.opacity = 1.0
        }) { _ in
            callback?()
        }
    }
    
    func fadeOut(animated: Bool, callback: (() -> Void)? = nil) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: { [weak self] in
            self?.layer.opacity = 0.0
        }) { [weak self] _ in
            guard let `self` = self else { return }
            self.isHidden = true
            self.stopAnimating()
            callback?()
        }
    }
    
    func startAnimating() {
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
    
    // MARK: - Private
    
    private let loadingIndicator = UIActivityIndicatorView()
}
