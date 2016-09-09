//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/1/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Properties
    var keyboardOnScreen = false
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextField: UITextView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    // UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        debugTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
//        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
//        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
//        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
//        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        unsubscribeFromAllNotifications()
    }
    
    // Actions
    @IBAction func loginPressed(sender: AnyObject) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextField.text = "Email or password field empty"
        } else {
            UdacityClient.sharedInstance().authenticateWithViewController(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        print(error)
                        self.displayError(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func completeLogin() {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Keyboard view management
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
}

// LoginViewController (Notifications)
extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// LoginViewController (Configure UI)
extension LoginViewController {
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextField.text = errorString
        }
    }
    
    private func setUIEnabled(enable: Bool) {
        emailTextField.enabled  = enable
        passwordTextField.enabled = enable
        loginButton.enabled = enable
        signUpButton.enabled = enable
        debugTextField.text = ""
        facebookLoginButton.enabled = enable
    }
    
    private func configureUI() {
        configureTextField(emailTextField)
        configureTextField(passwordTextField)
    }
    
    private func configureTextField(textField: UITextField) {
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:0.75)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.delegate = self
    }
}