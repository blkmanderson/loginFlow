//
//  WelcomeViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/16/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController, cUITextFieldListener {

    static var isMainView: Bool = true
    
    var handle: AuthStateDidChangeListenerHandle?
    var isActive: Bool = false
    
    let slideView = UIView(frame: CGRect(x: 27, y: 45.52, width: 321, height: 493.48))
    
    let logoImage = UIImageView(frame: CGRect(x: 97, y: 0, width: 126, height: 126))
    
    let signupLabel = UILabel(frame: CGRect(x: 125, y: 156, width: 71, height: 24))
    
    let nameField = cUITextField(frame: .zero, label: "Full Name", type: .regular)
    let emailField = cUITextField(frame: .zero, label: "Email", type: .regular)
    let passwordField = cUITextField(frame: .zero, label: "Password", type: .secure)
    
    let personIcon = UIImageView(frame: CGRect(x: 0, y: 210, width: 16, height: 16))
    let envelopeIcon = UIImageView(frame: CGRect(x: 0, y: 293, width: 16, height: 12))
    let lockIcon = UIImageView(frame: CGRect(x: 0, y: 372, width: 16, height: 16))
    
    let alreadyHaveLabel = UILabel(frame: CGRect(x: 130, y: 586, width: 116, height: 11))
    
    let continueButton = cUIButton(frame: .zero, size: .medium, scheme: .filled)
    let loginButton = cUIButton(frame: .zero, size: .large, scheme: .outlined)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    
        logoImage.image = UIImage(named: "logo")
        self.slideView.addSubview(logoImage)
        
        signupLabel.text = "Sign Up"
        signupLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        signupLabel.adjustsFontSizeToFitWidth = true
        signupLabel.textAlignment = .center
        signupLabel.textColor = lightGrey
        self.slideView.addSubview(signupLabel)
        
        personIcon.image = UIImage(named: "person")
        self.slideView.addSubview(personIcon)
        
        nameField.frame.origin = CGPoint(x: 21, y: 180)
        nameField.returnKeyType(.next)
        nameField.registerListener(self)
        nameField.tag = 0
        self.slideView.addSubview(nameField)
      
        envelopeIcon.image = UIImage(named: "envelope")
        self.slideView.addSubview(envelopeIcon)
        
        emailField.frame.origin = CGPoint(x: 21, y: 261)
        emailField.registerListener(self)
        emailField.keyBoardType(.emailAddress)
        emailField.returnKeyType(.next)
        emailField.tag = 1
        self.slideView.addSubview(emailField)
        
        lockIcon.image = UIImage(named: "lock")
        self.slideView.addSubview(lockIcon)
        
        passwordField.frame.origin = CGPoint(x: 21, y: 342)
        passwordField.registerListener(self)
        passwordField.returnKeyType(.done)
        passwordField.tag = 3
        self.slideView.addSubview(passwordField)
        
        continueButton.addTarget(self, action: #selector(toggleDown), for: .touchDown)
        continueButton.addTarget(self, action: #selector(toggleUp), for: .touchUpOutside)
        continueButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        continueButton.frame.origin = CGPoint(x: 86, y: 449)
        continueButton.setTitle("CONTINUE", for: .normal)
        self.slideView.addSubview(continueButton)
        
        self.view.addSubview(slideView)
        
        alreadyHaveLabel.text = "Already have an account?"
        alreadyHaveLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        alreadyHaveLabel.adjustsFontSizeToFitWidth = true
        alreadyHaveLabel.textColor = lightGrey
        self.view.addSubview(alreadyHaveLabel)
        
        loginButton.addTarget(self, action: #selector(toggleDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(toggleUp), for: .touchUpOutside)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.frame.origin = CGPoint(x: 10, y: 607)
        loginButton.setTitle("LOGIN", for: .normal)
        self.view.addSubview(loginButton)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(findFirstResponder)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func textFieldActive() {
        self.isActive = true
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.init(rawValue: 7), animations: {
            self.slideView.frame = self.slideView.frame.offsetBy(dx: 0, dy: -160)
        }, completion: nil)
    }
    
    func textFieldDeactive() {
        self.isActive = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.init(rawValue: 7), animations: {
            self.slideView.frame = self.slideView.frame.offsetBy(dx: 0, dy: 160)
        }, completion: nil)
    }
    
    @objc func findFirstResponder() {
        if nameField.isFirstResponder() {
            nameField.resign()
        } else if emailField.isFirstResponder() {
            emailField.resign()
        } else if passwordField.isFirstResponder() {
            passwordField.resign()
        }
    }
    
    @objc func toggleDown(_ sender: cUIButton) {
        sender.touchDown()
    }
    
    @objc func toggleUp(_ sender: cUIButton) {
        sender.touchUp()
    }
 
    @objc func create(_ sender: cUIButton) {
        sender.touchUp()
        
        if nameField.isEmpty() {
            nameField.error(msg: "Field required.")
            return
        }
        if emailField.isEmpty() {
            emailField.error(msg: "Field required.")
            return
        }
        if passwordField.isEmpty() {
            passwordField.error(msg: "Field required.")
            return
        }
        
        let db = Database.database().reference().child("users")
        
        Auth.auth().createUser(withEmail: emailField.getText()!, password: passwordField.getText()!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else{
                print(error!.localizedDescription)
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        self.emailField.error(msg: "Email already in use.")
                    case .invalidEmail:
                        self.emailField.error(msg: "Email is invalid.")
                    case .weakPassword:
                        self.emailField.error(msg: "Password must be at least 6 characters.")
                    default:
                        print("Another error")
                    }
                }
                return
            }
            
            let request = user.createProfileChangeRequest()
                
            request.displayName = self.nameField.getText()
            request.commitChanges { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            db.child(user.uid).setValue(["cgPicked": 0])
            
            let vc = UINavigationController(rootViewController: ProfilePickerViewController())
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
        
        
    @objc func login(_ sender: cUIButton) {
        sender.touchUp()
        
        WelcomeViewController.isMainView = false
        
        let vc = LoginViewController()
        self.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    /*
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        if WelcomeViewController.isMainView {
            UIView.animate(withDuration: duration) {
                self.moveableField.center = CGPoint(x: 201.239, y: 338.263)
                self.logoImage.center = CGPoint(x: 207.605, y: -92)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        if WelcomeViewController.isMainView {
            UIView.animate(withDuration: duration) {
                self.moveableField.center = CGPoint(x: 204.428, y: 537.725)
                self.logoImage.center = CGPoint(x: 207.605, y: 199.604)
            }
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
*/
}
