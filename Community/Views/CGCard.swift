//
//  CGCard.swift
//  Community
//
//  Created by Blake Anderson on 12/17/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CGCard: UICollectionViewCell {
    
    static var identifier: String = "card"
    
    let frontView = UIView(frame: CGRect(x: 0, y: 0, width: 360, height: 577))
    
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 369.453, width: 360, height: 31.682))
    let locationLabel = UILabel(frame: CGRect(x: 5, y: 324.873, width: 360, height: 45))
    let avatarImage = UIImageView(frame: CGRect(x: 110.061, y: 168.5, width: 150, height: 150))
    let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 360, height: 240))
    let timeCard = TimeCard(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 360, height: 577)
        self.backgroundColor = .clear
        
        // Front View Setup
        frontView.layer.cornerRadius = 20
        frontView.backgroundColor = .white
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        frontView.addSubview(nameLabel)
        
        mapView.isUserInteractionEnabled = false
        frontView.addSubview(mapView)
        
        avatarImage.makeRounded()
        frontView.addSubview(avatarImage)
        
        locationLabel.font = UIFont.boldSystemFont(ofSize: 32)
        locationLabel.textAlignment = .center
        locationLabel.adjustsFontSizeToFitWidth = true
        frontView.addSubview(locationLabel)
        
        frontView.addSubview(timeCard)
        
        self.addSubview(frontView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
   }
    
    func updateMapView(coordinates: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03 )
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.mapView.setRegion(region, animated: false)
    }
    
    func updateTime(time: String) {
        timeCard.updateEmail(time: time)
    }
    
    func expand() {
        

    }
    
    func shrink() {
        self.center = CGPoint(x: self.bounds.midX - 25, y: self.bounds.midY - 50)
    }
}

extension UIImageView {

    func makeRounded() {

        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    
    }
}
