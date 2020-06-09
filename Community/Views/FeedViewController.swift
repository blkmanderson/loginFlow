//
//  FeedViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/19/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import Firebase
import JJFloatingActionButton

class FeedViewController: UIViewController {
    
    var tabController: TabBarViewController?
    var activities: [Activity] = []
    
    let feedTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY), style: .plain)
    let actionButton = JJFloatingActionButton()
    
    var listener: ListenerRegistration?
    var cgName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        

        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 190.5
        feedTableView.separatorStyle = .none
        
        self.view.addSubview(feedTableView)
        
        actionButton.addItem(title: "Prayer", image: UIImage(named: "prayItem")) { (item) in
            self.createActivity(type: 0)
        }
        actionButton.addItem(title: "Praise", image: UIImage(named: "praiseItem")) { (itme) in
            self.createActivity(type: 1)
        }
        actionButton.addItem(title: "Announcement", image: UIImage(named: "noticeItem")) { (item) in
            self.createActivity(type: 2)
        }
        
        actionButton.itemAnimationConfiguration = .popUp()
        actionButton.buttonAnimationConfiguration.opening.duration = 0.5
        actionButton.buttonColor = secondaryColor
        actionButton.itemSizeRatio = CGFloat(0.85)
        actionButton.configureDefaultItem { (item) in
            item.layer.shadowOffset = CGSize(width: 0, height: 3)
            item.layer.shadowRadius = CGFloat(4)
            item.layer.shadowOpacity = Float(0.6)
            item.layer.shadowColor = primaryColor.cgColor
            
            item.buttonImageColor = UIColor(red:1.0, green:87/255, blue:148/255, alpha:150/255)
            item.titleLabel.textColor = .black
        }
        actionButton.overlayView.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.9)
        self.view.addSubview(actionButton)
        actionButton.display(inViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabController = self.tabBarController as? TabBarViewController
        self.navigationItem.title = tabController?.cgName
        self.cgName = tabController?.cgName
        
        if self.listener == nil {
            let fs = Firestore.firestore().collection("communityGroup").document(self.cgName!).collection("activities").order(by: "date", descending: false)
            self.listener = fs.addSnapshotListener({ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let activity = Activity(dictionary: diff.document.data())
                        self.activities.insert(activity, at: 0)
                    }
                    if (diff.type == .removed) {
                        print("Removed activity: \(diff.document.data())")
                    }
                }
                self.feedTableView.reloadData()
            })
        }
        self.feedTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func createActivity(type: Int) {
        let vc = UINavigationController(rootViewController: CreateActivityViewController(type: type, cgName: self.cgName!, name: self.tabController!.user!.displayName!))
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 

        
        return cell
    }
}

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}
