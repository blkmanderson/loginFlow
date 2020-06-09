//
//  TabBarControllerViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/19/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var cgName: String?
    var user: User?
    var group: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = secondaryColor
        
        let middleTab = UINavigationController(rootViewController: FeedViewController())
        let middleItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let rightTab = EventsViewController()
        let rightItem = UITabBarItem(title: nil, image: UIImage(systemName: "calendar"), tag: 2)
        
        middleTab.tabBarItem = middleItem
        rightTab.tabBarItem = rightItem
        
        let tabBarList = [ middleTab, rightTab]
        
        viewControllers = tabBarList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Database.database().reference().child("users")
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                
                self.user = user
                
                db.child(user!.uid).observe(.value) { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let bool = value?["cgPicked"] as? Int ?? 0
                    if bool == 0 {
                        let vc = UINavigationController(rootViewController: ProfilePickerViewController())
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    } else {
                        for child in self.children {
                            child.dismiss(animated: true, completion: nil)
                        }
                        self.selectedIndex = 1
                        self.cgName = value?["cg"] as? String
                        
                        _ = Firestore.firestore().collection("communityGroup").document(self.cgName!).collection("users").document("nameAndPic").addSnapshotListener { (snapshot, error) in
                            if let snapshot = snapshot {
                                if let data = snapshot.data() {
                                    for element in data {
                                        self.group.updateValue(element.value, forKey: element.key)
                                        print("Member added.")
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                let vc = WelcomeViewController()
                self.addChild(WelcomeViewController())
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
                self.user = nil
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
