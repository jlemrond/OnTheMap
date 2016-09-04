//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/3/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import UIKit

class LoginAuthViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func beginLogin(sender: AnyObject) {

        // Remove Keyboard from View.
        resignFirstResponderForAll()

        // Check if both textFields have information.
        guard (!usernameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty) else {
            errorMessageLabel.text = "Please enter a username and password"
            return
        }

        print(usernameTextField.text)


    }

    func resignFirstResponderForAll() {
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        }

        if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }

    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        resignFirstResponderForAll()
    }
}


extension LoginAuthViewController : UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
