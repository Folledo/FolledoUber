//
//  KeyboardViewController.swift
//  MyKeyboard
//
//  Created by Samuel Folledo on 7/11/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    @objc func pikachuTapped() { //custom keyboard //9mins
        let proxy = textDocumentProxy as UITextDocumentProxy //custom keyboard //9mins
        proxy.insertText("Pikachu!") //custom keyboard //10mins
    }
    @objc func charmanderTapped() { //custom keyboard //9mins
        let proxy = textDocumentProxy as UITextDocumentProxy //custom keyboard //9mins
        proxy.insertText("Charmander!") //custom keyboard //10mins
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pikachuButton = UIButton(type: .system) //custom keyboard //6mins
        let charmanderButton = UIButton(type: .system) //custom keyboard //6mins
        pikachuButton.setBackgroundImage(UIImage(named: "pikachu"), for: .normal) //custom keyboard //7mins
        charmanderButton.setBackgroundImage(UIImage(named: "charmander"), for: .normal) //custom keyboard //7mins
        pikachuButton.frame = CGRect(x: 50, y: 40, width: 80, height: 100) //custom keyboard //8mins
        charmanderButton.frame = CGRect(x: 150, y: 40, width: 80, height: 100) //custom keyboard //8mins
        pikachuButton.addTarget(self, action: #selector(KeyboardViewController.pikachuTapped), for: .touchUpInside) //custom keyboard //8mins
        charmanderButton.addTarget(self, action: #selector(KeyboardViewController.charmanderTapped), for: .touchUpInside) //custom keyboard //8mins
        view.addSubview(pikachuButton) //custom keyboard //9mins
        view.addSubview(charmanderButton) //custom keyboard //9mins
        
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Folledo Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
