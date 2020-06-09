//
//  CreateActivityViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/20/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Firebase

class CreateActivityViewController: UIViewController {
    
    let profilePic = UIImageView(frame: CGRect(x: 15, y: 89, width: 45.621, height: 45.621))
    let nameLabel = UILabel(frame: CGRect(x: 69.456, y: 89, width: 120.972, height: 38.871))
    let timeLabel = UILabel(frame: CGRect(x: 69.456, y: 118.92, width: 120, height: 13.491))
    let bodyField = UITextView(frame: CGRect(x: 15, y: 164, width: 384, height: 749))
    
    let postButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(post))
    
    var type: Int?
    var typeString: String?
    var cgName: String?
    var displayName: String?
    
    
    init(type: Int, cgName: String, name: String) {
        super.init(nibName: nil, bundle: nil)

        self.type = type
        
        switch type {
        case 0:
            self.typeString = "Prayer Request"
        case 1:
            self.typeString = "Praise Report"
        case 2:
            self.typeString = "Announcement"
        default:
            self.typeString = " "
        }
        
        self.cgName = cgName
        self.displayName = name
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        self.navigationController?.navigationBar.tintColor = primaryColor
        self.navigationItem.rightBarButtonItem = postButton
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.title = typeString!

        profilePic.image = UIImage(named: "avatar")
        self.view.addSubview(profilePic)
        
        nameLabel.text = displayName
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(nameLabel)
        
        timeLabel.text = cgName
        timeLabel.textColor = secondaryColor
        timeLabel.font = UIFont.systemFont(ofSize: 11.5, weight: .regular)
        timeLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(timeLabel)
        
        bodyField.isEditable = true
        bodyField.font = UIFont.systemFont(ofSize: 14)
        bodyField.placeholder = "Start typing..."
        self.view.addSubview(bodyField)
        
        self.drawLineFromPoint(start: CGPoint(x: 15, y: 154), toPoint: CGPoint(x: 399, y: 154), ofColor: lightGrey, inView: self.view)
        
    }
    
    @objc func post() {
        
        let activity: [String:Any] = [
            "author": self.nameLabel.text!,
            "date": Date(),
            "type": self.type!,
            "body": self.bodyField.text!,
            "commentCount": 0
        ]
        
        _ = Firestore.firestore().collection("communityGroup").document(cgName!).collection("activities").addDocument(data: activity) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Document added!")
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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

extension CreateActivityViewController {
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {

        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0

        view.layer.addSublayer(shapeLayer)
    }
}


