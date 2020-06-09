//
//  ActivityCell.swift
//  Community
//
//  Created by Blake Anderson on 12/20/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    let profilePic = UIImageView(frame: CGRect(x: 15, y: 10, width: 45.621, height: 45.621))
    let nameLabel = UILabel(frame: CGRect(x: 69.456, y: 10, width: 120.972, height: 38.871))
    let timeLabel = UILabel(frame: CGRect(x: 69.456, y: 39.92, width: 120.972, height: 13.491))
    let moreInfoImage = UIImageView(frame: CGRect(x: 495.71, y: 15.49, width: 3, height: 15))
    let typeImage = UIImageView(frame: CGRect(x: 38.979, y: 85.666, width: 41.976, height: 31.157))
    let bodyLabel = UILabel(frame: CGRect(x: 99.05, y: 68.915, width: 252.882, height: 64.56))
    let commentImage = UIImageView(frame: CGRect(x: 350.412, y: 154.565, width: 16, height: 16))
    let commentCount = UILabel(frame: CGRect(x: 374.412, y: 154.555, width: 15.572, height: 17.281))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 384.028, height: 180)
        self.backgroundColor = .white
        
        profilePic.image = UIImage(named: "avatar")
        self.addSubview(profilePic)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(nameLabel)
        
        timeLabel.textColor = secondaryColor
        timeLabel.font = UIFont.systemFont(ofSize: 11.5, weight: .regular)
        timeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(timeLabel)
        
        moreInfoImage.image = UIImage(named: "more")
        self.addSubview(moreInfoImage)
        
        
        self.addSubview(typeImage)
        
        bodyLabel.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyLabel.numberOfLines = 3
        self.addSubview(bodyLabel)
        
        commentImage.image = UIImage(systemName: "bubble.left.and.bubble.right")
        commentImage.tintColor = .black
        self.addSubview(commentImage)
        
        commentCount.text = "0"
        commentCount.adjustsFontSizeToFitWidth = true
        commentCount.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.addSubview(commentCount)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
