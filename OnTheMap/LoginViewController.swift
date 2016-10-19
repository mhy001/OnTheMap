//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mark Yang on 9/1/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    let udacityClient = UdacityClient.sharedInstance()
    var keyboardOnScreen = false
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextField: UITextView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        debugTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Actions
    @IBAction func loginPressed(_ sender: AnyObject) {

        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError(host: self, error: NSError(domain: "loginPressed", code: ErrorCodes.User, userInfo: [NSLocalizedDescriptionKey: ErrorStrings.EmptyCredentials]))
        } else {
            let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            loadingIndicator.center = view.center
            loadingIndicator.startAnimating()
            view.addSubview(loadingIndicator)
            setUIEnabled(false)

            udacityClient.authenticate(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                performUIUpdatesOnMain {
                    loadingIndicator.stopAnimating()
                    loadingIndicator.removeFromSuperview()
                    self.setUIEnabled(true)
                }
                if success {
                    performUIUpdatesOnMain {
                        self.completeLogin()
                    }
                } else {
                    if let error = error {
                        displayError(host: self, error: error)
                    } else {
                        print(ErrorStrings.WHATHAPPENED)
                    }
                }
            }
        }
    }

    @IBAction func signUpPressed(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    
    fileprivate func completeLogin() {

        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController

        present(controller, animated: true, completion: nil)
    }
}

// MARK: LoginViewController (Notifications)
extension LoginViewController {
    
    fileprivate func subscribeToNotification(_ notification: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: notification), object: nil)
    }
    
    fileprivate func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: LoginViewController (UI)
extension LoginViewController {
    
    fileprivate func setUIEnabled(_ enable: Bool) {

        emailTextField.isEnabled  = enable
        passwordTextField.isEnabled = enable
        loginButton.isEnabled = enable
        signUpButton.isEnabled = enable
        debugTextField.text = ""
        //facebookLoginButton.isEnabled = enable

        loginButton.alpha = enable ? 1.0 : 0.5
        signUpButton.alpha = enable ? 1.0 : 0.5
        //facebookLoginButton.alpha = enable ? 1.0 : 0.5
    }
    
    fileprivate func configureUI() {

        configureTextField(emailTextField)
        configureTextField(passwordTextField)

        setUIEnabled(true)
    }
    
    fileprivate func configureTextField(_ textField: UITextField) {

        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:0.75)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
}
