//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/3/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import UIKit

// MARK: Login Auth View Controller

class LoginAuthViewController: UIViewController {


    // MARK: Variables

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!


    // MARK: Standard Load/Appear Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up Text Field Apperance
        passwordTextField.secureTextEntry = true
        for item in [usernameTextField, passwordTextField] {
            item.delegate = self
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: item.frame.height))
            item.leftView = padding
            item.leftViewMode = .Always
        }
    }

    override func viewWillAppear(animated: Bool) {
        interfaceEnabled(true)
    }
    

    override func viewWillDisappear(animated: Bool) {
        // Ensure password is not stored.
        passwordTextField.text = ""
    }


    // MARK: Functions

    /// Begin Udacity Login Procedure
    @IBAction func beginLogin(sender: AnyObject) {

        resignFirstResponderForAll()

        // Check if both textFields have information.
        guard (!usernameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty) else {
            errorMessageLabel.text = "Please enter a username and password"
            return
        }

        interfaceEnabled(false)

        // Perform request on High Priority Thread and display the next
        // view controller on the Main Thread.
        performHighPriority {
            UdacityClient.sharedInstance.getSessionID(username: self.usernameTextField.text!, password: self.passwordTextField.text!) { (error) in
                performOnMain({

                    if error != nil {
                        self.displayOneButtonAlert("Oops", message: error)
                        self.interfaceEnabled(true)
                    } else {
                        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("MapAndTableNavigation") as! UINavigationController
                        self.presentViewController(tabBarController, animated: true, completion: nil)
                    }
                })
            }
        }
    }


    /// Toggle interface.
    func interfaceEnabled(enabled: Bool) {
        performOnMain { 
            self.usernameTextField.enabled = enabled
            self.passwordTextField.enabled = enabled
            self.submitButton.enabled = enabled
            self.signUpButton.enabled = enabled
        }
    }


    /// Send user to Udacity's sign up page.
    @IBAction func didTapSignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(UdacityClient.SignUp.url)
    }


    /// Resigns first responder for both text fields on this View.
    func resignFirstResponderForAll() {
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        }

        if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }


    /// Resign Keyboard if the region outside of the keyboard is selected.
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        resignFirstResponderForAll()
    }
}



// MARK: - UI Text Field Delegate

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
