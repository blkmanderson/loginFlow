//
//  CommunityGroup.swift
//  Community
//
//  Created by Blake Anderson on 12/17/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import Foundation
import CoreLocation

struct CommunityGroup: Hashable, Codable, Identifiable {
    
    var id: Int
    var imageName: String
    var name: String
    var coordinates: Coordinates
    var shepards: String
    var contact: String
    var day: String
    
    var locationCoordinate: CLLocationCoordinate2D {

        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
    }
    
}

struct Coordinates: Hashable, Codable {
    
    var latitude: Double
    var longitude: Double
    
}
