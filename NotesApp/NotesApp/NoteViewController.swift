//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import NotesShared
import UIKit

class NoteViewController: UIViewController {
    
    var note: Note? {
        didSet {
            textView.text = note?.note
            updateContents()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        textView.delegate = self
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateContents()
    }
    
    // MARK: - Private
    
    private var newNoteContent: String?
    
    private let noteDataSource = NoteDataSource()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        return view
    }()
    
    private let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    
    fileprivate func updateContents() {
        guard let text = textView.text else { return }
        
        newNoteContent = text
        
        let range = text.range(of: "\n")
        title = text.substring(to: range?.lowerBound ?? text.endIndex)
    }
    
    func saveTapped() {
        
    }
}

extension NoteViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateContents()
    }
}
