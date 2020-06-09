//
//  EmailCard.swift
//  Community
//
//  Created by Blake Anderson on 12/18/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit

class TimeCard: UIView {
    
    var timeImage = UIImageView(frame: CGRect(x: 53.424, y: 32.372, width: 35.375, height: 35.375))
    var label = UILabel(frame: CGRect(x: 0, y: 71.347, width: 144.152, height: 15))
    var timeLabel = UILabel(frame: CGRect(x: 5, y: 89.915, width: 134.152, height: 14.5))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 112.848, y: 414.388, width: 144.152, height: 145.921)
        
        timeImage.image = UIImage(named: "time")
        self.addSubview(timeImage)
        
        label.text = "Meeting Time"
        label.font = UIFont.systemFont(ofSize: 12.4, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.addSubview(label)
        
        timeLabel.font = UIFont.systemFont(ofSize: 12.4, weight: .regular)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(timeLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateEmail(time: String) {
        timeLabel.text = time
    }
}
