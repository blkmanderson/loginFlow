//
//  cUIProfileImageView.swift
//  Community
//
//  Created by Blake Anderson on 1/20/20.
//  Copyright © 2020 Blake Anderson. All rights reserved.
//

import UIKit

class cUIProfileImageView: UIImageView {
    
    init(frame: CGRect, size: cUIProfileImageViewSize, shadow: cUIProfileImageViewShadow) {
        super.init(frame: frame)
        
        setup(size, shadow)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(_ size: cUIProfileImageViewSize,_ shadow: cUIProfileImageViewShadow) {
        
        switch size {
        case .large:
            self.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        case .small:
            self.frame = CGRect(x: 0, y: 0, width: 53.33, height: 53.33)
        }
        
        switch shadow {
        case .yes:
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 0.13
            self.layer.masksToBounds = false
        case .no:
            print("No shadow")
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = lightGrey.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}

enum cUIProfileImageViewSize {
    case small
    case large
}
enum cUIProfileImageViewShadow {
    case yes
    case no
}
