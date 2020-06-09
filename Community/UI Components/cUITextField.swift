//
//  cUITextField.swift
//  Community
//
//  Created by Blake Anderson on 1/16/20.
//  Copyright © 2020 Blake Anderson. All rights reserved.
//

import UIKit

class cUITextField: UIView, UITextFieldDelegate {
    
    private var label: UILabel?
    private var errorLabel: UILabel?
    
    private var textField: UITextField?
    
    private var textExists: Bool?
    private var errorExists: Bool?
    
    private var cUITextFieldListener: cUITextFieldListener?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, label: String, type: cUITextFieldType) {
        super.init(frame: frame)
        
        setup(label, type)
    }

    
    private func setup(_ label: String,_ type: cUITextFieldType) {
        
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        
        self.textField = UITextField(frame: CGRect(x: 0, y: 15, width: 300, height: 45))
        
        self.textField?.delegate = self
        
        self.textField?.layer.cornerRadius = 10
        self.textField?.layer.borderColor = lightGrey.cgColor
        self.textField?.layer.borderWidth = 1
        self.textField?.leftView = UIView(frame: CGRect(x:0, y:0, width: 10, height: 1))
        self.textField?.leftViewMode = .always
        self.textField?.textColor = .black
        
        if type == .secure {
            self.textField?.isSecureTextEntry = true
        }
        
        self.label = UILabel(frame: CGRect(x: 10, y: 30, width: 250, height: 15))
        self.label?.text = label
        self.label?.font = UIFont.systemFont(ofSize: 13)
        self.label?.textColor = UIColor.black.withAlphaComponent(0.40)
        
        self.errorLabel = UILabel(frame: CGRect(x: 150, y: 0, width: 140, height: 15))
        self.errorLabel?.text = label
        self.errorLabel?.font = UIFont.systemFont(ofSize: 13)
        self.errorLabel?.textColor = .red
        self.errorLabel?.textAlignment = .right
        self.errorLabel?.adjustsFontSizeToFitWidth = true
        self.errorLabel?.isHidden = true
        
        self.addSubview(self.textField!)
        self.addSubview(self.label!)
        self.addSubview(self.errorLabel!)
        
        self.textExists = false
        self.errorExists = false
    }
    
    func getText() -> String? {
        return self.textField?.text
    }
    
    func resign() {
        self.textField?.resignFirstResponder()
    }
    func respond() {
        self.textField?.becomeFirstResponder()
    }
    func isFirstResponder() -> Bool {
        return textField!.isFirstResponder
    }
    func isEmpty() -> Bool {
        return self.textField!.text!.isEmpty
    }
    func registerListener(_ listener: cUITextFieldListener) {
        self.cUITextFieldListener = listener
    }
    func removeListener() {
        self.cUITextFieldListener = nil
    }
    func keyBoardType(_ keyboard: UIKeyboardType) {
        self.textField?.keyboardType = keyboard
    }
    func returnKeyType(_ key: UIReturnKeyType) {
        self.textField?.returnKeyType = key
    }
    
}

enum cUITextFieldType {
    case regular
    case secure
}

extension cUITextField {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selected()
        
        if cUITextFieldListener?.isActive == false {
            cUITextFieldListener?.textFieldActive()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cUITextFieldListener?.textFieldDeactive()
       
        if(textField.text == "") {
            self.deselected()
            textExists = false
        } else {
            textExists = true
            self.textField?.layer.borderColor = primaryColor.cgColor
            self.label!.textColor = primaryColor
            self.errorLabel?.isHidden = true
        }
    }
    
    func selected() {
        
        if textExists! == false {
            UIView.animate(withDuration: 0.1) {
                self.label!.textColor = primaryColor
                self.label!.frame = self.label!.frame.offsetBy(dx: 0, dy: -30)
                self.textField?.layer.borderColor = primaryColor.cgColor
                self.errorLabel?.isHidden = true
            }
        }
    }
    
    func deselected()  {
        UIView.animate(withDuration: 0.1) {
            self.label!.textColor = UIColor.black.withAlphaComponent(0.40)
            self.label!.frame = self.label!.frame.offsetBy(dx: 0, dy: 30)
            self.textField?.layer.borderColor = lightGrey.cgColor
            self.errorLabel?.isHidden = true
        }
    }
    
    func error(msg: String) {
        UIView.animate(withDuration: 0.1) {
            self.label!.textColor = UIColor.red
            self.textField!.layer.borderColor = UIColor.red.cgColor
            self.errorLabel?.text = msg
            self.errorLabel?.isHidden = false
            
            self.errorExists = true
        }
        self.shake()
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
