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

    override func viewWillDisappear(animated: Bool) {
        // Ensure password is not stored.
        passwordTextField.text = ""
    }

    @IBAction func beginLogin(sender: AnyObject) {

        // TODO: Disable Buttons when pressed.

        // Remove Keyboard from View.
        resignFirstResponderForAll()

        // Check if both textFields have information.
        guard (!usernameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty) else {
            errorMessageLabel.text = "Please enter a username and password"
            return
        }

        // Perform request on High Priority Thread and display the next
        // view controller on the Main Thread.
        performHighPriority {
            UdacityClient.sharedInstance.getSessionID(username: self.usernameTextField.text!, password: self.passwordTextField.text!) { (error) in
                performOnMain({

                    if error != nil {
                        self.errorMessageLabel.text = error
                    } else {
                        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("MapAndTableNavigation") as! UINavigationController
                        self.presentViewController(tabBarController, animated: true, completion: nil)
                    }
                })
            }
        }

    }

    @IBAction func didTapSignUp(sender: AnyObject) {

        UIApplication.sharedApplication().openURL(UdacityClient.SignUp.url)

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


extension LoginAuthViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        return true
    }


}
