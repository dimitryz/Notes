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
        textView.keyboardDismissMode = .interactive
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateContents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.contentOffset = CGPoint(x: 0, y: -textView.contentInset.top)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard handling
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let window = view.window,
            let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationCurve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else { return }
        
        let ownFrame = view.convert(textView.frame, to: window)
        let coveredFrame = ownFrame.intersection(keyboardFrame)
        
        var newInset = textView.contentInset
        newInset.bottom = coveredFrame.height
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: animationCurve << 16),
            animations: { [weak self] in
                guard let `self` = self else { return }
                
                self.textView.contentInset = newInset
                self.textView.scrollIndicatorInsets = newInset
        })
    }
    
    // MARK: - Private
    
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
        guard let rootViewController = navigationController as? RootViewController else { return }
        rootViewController.hideLoading(callback: callback)
    }
    
    fileprivate func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showLoadingIndicator(callback: (() -> Void)?) {
        guard let rootViewController = navigationController as? RootViewController else { return }
        rootViewController.showLoading(callback: callback)
    }
    
    
    fileprivate func updateSaveButtonState() {
        saveButton.isEnabled = newNoteContent != note?.note
    }
}

// MARK: - Button handling

extension NoteViewController {
    
    func saveTapped() {
        guard
            let originalNote = self.note,
            let newNoteContent = newNoteContent
            else { return }
        
        let newNote = originalNote.copy() as! Note
        newNote.note = newNoteContent
        
        showLoadingIndicator { [weak self] in
            guard let sSelf = self else { return }
            
            _ = sSelf.noteDataSource.save(note: newNote, callback: { [weak self] (newNote, error) in
                
                self?.hideLoadingIndicator { [weak self] in
                    guard let sSelf = self else { return }
                    
                    if let error = error {
                        sSelf.showError(error: error)
                    } else {
                        originalNote.key = newNote.key
                        originalNote.note = newNote.note
                        sSelf.updateSaveButtonState()
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
