//
//  EventsViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/20/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import Firebase
import UIKit

class EventsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let button = UIButton()
        
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(logout), for: .touchDown)
        
        self.view.addSubview(button)
    }
    
     @objc func logout() {
           do {
               try Auth.auth().signOut()
           } catch {
               
           }
           
       }
}
