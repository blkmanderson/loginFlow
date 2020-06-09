//
//  ButtonAnimation.swift
//  Community
//
//  Created by Blake Anderson on 12/19/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func pulse() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.25
        pulse.fromValue = 0.95
        pulse.toValue = 1.00
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
