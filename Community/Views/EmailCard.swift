//
//  EmailCard.swift
//  Community
//
//  Created by Blake Anderson on 12/18/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit

class EmailCard: UIView {
    
    let emailImage = UIImageView(frame: CGRect(x: 27.5, y: 28.5, width: 35.375, height: 35.375))
    let emailLabel = UILabel(frame: CGRect(x: 86.235, y: 28.626, width: 238.765, height: 31.739))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 25, y: 547, width: 360, height: 90)
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        
        emailImage.image = UIImage(named: "emailCard")
        self.addSubview(emailImage)
        
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        self.addSubview(emailLabel)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateEmail(email: String) {
        self.emailLabel.text = email
    }
}
