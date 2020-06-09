//
//  cUITextFieldListener.swift
//  Community
//
//  Created by Blake Anderson on 1/16/20.
//  Copyright © 2020 Blake Anderson. All rights reserved.
//

import Foundation

protocol cUITextFieldListener {
    
    var isActive: Bool {get set}
    func textFieldActive()
    func textFieldDeactive()
}
