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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordTF.errorValidationHandler = { [weak self] text in
            guard let strongSelf = self else { return "newPasswordTF.placeholder" }
            let passwordRegEx = "^[A-Za-z0-9\\.\\@\\-\\_\\,]{6,20}$"
            
            let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            let match = passwordTest.evaluate(with: text)
            if match {
                strongSelf.newPasswordTF.borderActiveColor = UIColor.black
                return nil
            } else {
                strongSelf.newPasswordTF.borderActiveColor = UIColor.red
                return strongSelf.newPasswordTF.placeholder
            }
        }
    }
}

