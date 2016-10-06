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

    @IBOutlet weak var emailTextField: BeautifulTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        
        emailTextField.errorValidationHandler = { text in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let match = emailTest.evaluate(with: text)
            if match {
                return nil
            } else {
                return "Invalid email"
            }
        }
    }
}

