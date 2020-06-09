//
//  ProfilePickerViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/22/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit

class ProfilePickerViewController: UIViewController, cUIPickerViewFieldListener {

    let titleLabel = UILabel(frame: CGRect(x: 139, y: 112, width: 98, height: 24))
    
    let imageView = cUIProfileImageView(frame: .zero, size: .large, shadow: .yes)
    let editPicButton = UIButton(frame: CGRect(x: 157, y: 304, width: 66, height: 12))
    
    var genderPicker: cUIPickerViewField
    var birthdayPicker: cUIPickerViewField
    
    let chooseButton = cUIButton(frame: .zero, size: .medium, scheme: .filled)
    
    var image: UIImage!
    var imagePicker: ImagePicker!
    
    init() {
        
        let genderData = ["Male", "Female"]
        self.genderPicker = cUIPickerViewField(frame: .zero, label: "Gender",data: genderData, type: .custom)
        self.birthdayPicker = cUIPickerViewField(frame: .zero, label: "Birthday", data: nil, type: .date)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let genderData = ["Male", "Female"]
        self.genderPicker = cUIPickerViewField(frame: .zero, label: "Gender",data: genderData, type: .custom)
        self.birthdayPicker = cUIPickerViewField(frame: .zero, label: "Birthday", data: nil, type: .date)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Edit Profile"
        titleLabel.textColor = lightGrey
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(titleLabel)
        
        self.view.backgroundColor = .white
        
        imageView.frame.origin = CGPoint(x: 108, y: 140)
        self.view.addSubview(imageView)
        
        
        self.genderPicker.frame.origin = CGPoint(x: 38, y: 336)
        self.genderPicker.registerViewListener(imageView)
        self.genderPicker.registerViewListener(titleLabel)
        self.genderPicker.registerViewListener(editPicButton)
        self.genderPicker.registerViewListener(birthdayPicker)
        self.genderPicker.registerViewListener(chooseButton)
        self.genderPicker.registerControllerListener(self)
        self.view.addSubview(genderPicker)
        
        self.birthdayPicker.frame.origin = CGPoint(x: 38, y: 416)
        self.birthdayPicker.registerViewListener(imageView)
        self.birthdayPicker.registerViewListener(titleLabel)
        self.birthdayPicker.registerViewListener(editPicButton)
        self.birthdayPicker.registerViewListener(genderPicker)
        self.birthdayPicker.registerViewListener(chooseButton)
        self.birthdayPicker.registerControllerListener(self)
        self.view.addSubview(birthdayPicker)
        
        editPicButton.setTitle("Edit Photo", for: .normal)
        editPicButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editPicButton.setTitleColor(primaryColor, for: .normal)
        editPicButton.addTarget(self, action: #selector(editPic(_:)), for: .touchDown)
        self.view.addSubview(editPicButton)
        
        chooseButton.frame.origin = CGPoint(x: 113, y: 511)
        chooseButton.setTitle("NEXT", for: .normal)
        chooseButton.addTarget(self, action: #selector(toggleDown(_:)), for: .touchDown)
        chooseButton.addTarget(self, action: #selector(toggleUp(_:)), for: .touchUpOutside)
        self.view.addSubview(chooseButton)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponder)))

    }
    
    @objc func toggleDown(_ sender: cUIButton) {
        sender.touchDown()
    }
    @objc func toggleUp(_ sender: cUIButton) {
        sender.touchUp()
        resignResponder()
    }
    
    @objc func resignResponder() {
        if birthdayPicker.isFirstResponder() {
            birthdayPicker.close()
        } else if genderPicker.isFirstResponder() {
            genderPicker.close()
        }
    }
    
    @objc func editPic(_ sender: UIView) {
        self.imagePicker.present(from: sender)
    }


    func lookForOtherResponder(_ field: cUIPickerViewField) {
        if birthdayPicker != field && birthdayPicker.isFirstResponder() {
            birthdayPicker.close()
        } else if genderPicker != field && genderPicker.isFirstResponder() {
            genderPicker.close()
        }
    }
}

extension ProfilePickerViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
        self.image = image
    }
}
