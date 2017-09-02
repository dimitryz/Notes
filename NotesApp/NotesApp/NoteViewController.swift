//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Dimitry Zolotaryov on 2017-08-27.
//  Copyright © 2017 Dimitry Zolotaryov. All rights reserved.
//

import NotesShared
import UIKit

protocol NoteViewControllerDelegate {
    func noteViewController(noteViewController: NoteViewController, didSaveNote note: Note)
}

class NoteViewController: UIViewController {
    
    var delegate: NoteViewControllerDelegate? = nil
    
    var note: Note? {
        didSet {
            textView.text = note?.note
            updateContents()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateContents()
    }
    
    // MARK: - Private
    
    private var loadingViewController: LoadingViewController?
    
    fileprivate let noteDataSource = NoteDataSource()
    
    private let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
    
    fileprivate var newNoteContent: String? {
        didSet {
            updateSaveButtonState()
        }
    }
    
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        return view
    }()
    
    fileprivate func updateContents() {
        guard let text = textView.text else { return }
        
        newNoteContent = text
        
        let range = text.range(of: "\n")
        title = text.substring(to: range?.lowerBound ?? text.endIndex)
    }
    
    fileprivate func hideLoadingIndicator(callback: (() -> Void)?) {
        loadingViewController?.dismiss(animated: true, completion: callback)
    }
    
    fileprivate func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showLoadingIndicator(callback: (() -> Void)?) {
        let loadingViewController = LoadingViewController()
        navigationController?.present(loadingViewController, animated: true, completion: callback)
        self.loadingViewController = loadingViewController
    }
    
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = newNoteContent != note?.note
    }
}

// MARK: - Button handling

extension NoteViewController {
    
    func saveTapped() {
        guard
            let note = self.note,
            let newNoteContent = newNoteContent
            else { return }
        
        let newNote = note.copy() as! Note
        newNote.note = newNoteContent
        
        showLoadingIndicator { [weak self] in
            guard let sSelf = self else { return }
            
            _ = sSelf.noteDataSource.update(note: newNote, callback: { [weak self] (_, error) in
                
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoadingIndicator { [weak self] in
                        guard
                            let sSelf = self,
                            let note = sSelf.note
                            else { return }
                        
                        if let error = error {
                            sSelf.showError(error: error)
                        } else {
                            note.note = newNoteContent
                            sSelf.delegate?.noteViewController(noteViewController: sSelf, didSaveNote: note)
                        }
                    }
                }
            })
        }
    }
}

// MARK: Text delegate

extension NoteViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateContents()
    }
}
