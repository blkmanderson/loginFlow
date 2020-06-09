//
//  LoginViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/16/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let welcomeLabel = UILabel(frame: CGRect(x: 118, y: 73, width: 140, height: 24))
    
    let emailField = cUITextField(frame: .zero, label: "Email", type: .regular)
    let passwordField = cUITextField(frame: .zero, label: "Password", type: .secure)
    
    let envelopeImage = UIImageView(frame: CGRect(x: 27, y: 137, width: 16, height: 12))
    let lockImage = UIImageView(frame: CGRect(x: 27, y: 218, width: 16, height: 16))
    
    let loginButton = cUIButton(frame: .zero, size: .medium, scheme: .filled)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        welcomeLabel.text = "Welcome Back!"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = lightGrey
        self.view.addSubview(welcomeLabel)

        emailField.frame.origin = CGPoint(x: 48, y: 107)
        emailField.keyBoardType(.emailAddress)
        emailField.returnKeyType(.next)
        self.view.addSubview(emailField)
        
        passwordField.frame.origin = CGPoint(x: 48, y: 188)
        passwordField.returnKeyType(.done)
        self.view.addSubview(passwordField)
        
        envelopeImage.image = UIImage(named: "envelope")
        self.view.addSubview(envelopeImage)
        
        lockImage.image = UIImage(named: "lock")
        self.view.addSubview(lockImage)
        
        loginButton.addTarget(self, action: #selector(toggleDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(toggleUp), for: .touchCancel)
        loginButton.addTarget(self, action: #selector(toggleUp), for: .touchUpOutside)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.frame.origin = CGPoint(x: 113, y: 289)
        self.view.addSubview(loginButton)
        
        setFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WelcomeViewController.isMainView =  true
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    func setFirstResponder() {
        emailField.respond()
    }
    
    @objc func toggleDown(_ sender: cUIButton) {
        sender.touchDown()
    }
    @objc func toggleUp(_ sender: cUIButton) {
        sender.touchUp()
    }
    
    @objc func login(_ sender: cUIButton) {
        
        sender.touchUp()
        
        if emailField.isEmpty() {
            emailField.error(msg: "Email cannot be empty.")
            return
        }
        if passwordField.isEmpty() {
            passwordField.error(msg: "Password cannot be empty. ")
            return
        }
        
        
        Auth.auth().signIn(withEmail: emailField.getText()!, password: passwordField.getText()!) { (authResults, error) in
            
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .invalidEmail:
                        self.emailField.error(msg: "Invalid email.")
                    case .wrongPassword:
                        self.passwordField.error(msg: "Incorrect password.")
                    default:
                        print("Another error")
                    }
                    return
                }
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
