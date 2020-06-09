//
//  cui_button.swift
//  Community
//
//  Created by Blake Anderson on 1/16/20.
//  Copyright © 2020 Blake Anderson. All rights reserved.
//

import UIKit

class cUIButton: UIButton {
    
    init(frame: CGRect, size: cuiButtonType, scheme: ColorScheme) {
        super.init(frame: frame)
        
        setup(size, scheme)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(_ size: cuiButtonType,_ scheme: ColorScheme) {
        
        switch size {
        case .small:
            self.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 30)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            break
        case .medium:
            self.frame = CGRect(x: 0, y: 0, width: 150, height: 45)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            break
        case .large:
            self.frame = CGRect(x: 0, y: 0, width: 355, height: 45)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            break
        }
        
        switch scheme {
        case .filled:
            self.backgroundColor = primaryColor
        case .outlined:
            self.backgroundColor = .white
            self.layer.borderColor = primaryColor.cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(primaryColor, for: .normal)
        case .disabled:
            self.backgroundColor = .white
            self.layer.borderWidth = 1
            self.layer.borderColor = primaryColor.withAlphaComponent(0.40).cgColor
            self.setTitleColor(primaryColor.withAlphaComponent(0.40), for: .normal)
            self.isUserInteractionEnabled = false
        }
        
        self.layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.13
        
        self.layer.masksToBounds = false
    }
}

enum cuiButtonType {
    case small
    case medium
    case large
}

enum ColorScheme {
    case filled
    case outlined
    case disabled
}


extension cUIButton {
    
    func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
