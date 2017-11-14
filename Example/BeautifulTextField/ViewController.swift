//
//  ViewController.swift
//  BeautifulTextField
//
//  Created by Dmitry Utmanov on 10/06/2016.
//  Copyright (c) 2016 Dmitry Utmanov. All rights reserved.
//

import UIKit
import BeautifulTextField

class ViewController: UIViewController {

    @IBOutlet weak var newPasswordTF: BeautifulTextField!
    @IBOutlet weak var newPasswordAgainTF: BeautifulTextField!
    @IBOutlet weak var oldPasswordTF: BeautifulTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordTF.textInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        newPasswordTF.validateOnEdit = false
        newPasswordTF.errorValidationHandler = { [weak self] text in
            guard let strongSelf = self else { return "newPasswordTF.placeholder" }
            let passwordRegEx = "^[A-Za-z0-9\\.\\@\\-\\_\\,]{6,20}$"
            
            let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            let match = passwordTest.evaluate(with: text)
            if match {
                strongSelf.newPasswordTF.borderInactiveColor = .lightGray
                return nil
            } else {
                strongSelf.newPasswordTF.borderInactiveColor = strongSelf.newPasswordTF.errorColor
                return strongSelf.newPasswordTF.placeholder
            }
        }
        newPasswordAgainTF.validateOnEdit = false
        newPasswordAgainTF.errorValidationHandler = { [weak self] text in
            guard let strongSelf = self else {
                return nil
            }
            guard strongSelf.newPasswordTF.isValid else {
                strongSelf.newPasswordAgainTF.borderInactiveColor = .lightGray
                return nil
            }
            
            let match = strongSelf.newPasswordAgainTF.text == strongSelf.newPasswordTF.text
            
            if match {
                strongSelf.newPasswordAgainTF.borderInactiveColor = .lightGray
                return nil
            } else {
                strongSelf.newPasswordAgainTF.borderInactiveColor = strongSelf.newPasswordAgainTF.errorColor
                return strongSelf.newPasswordAgainTF.placeholder
            }
        }
    }
    @IBAction func saveTap(_ sender: Any) {
        view.endEditing(true)
    }
}

