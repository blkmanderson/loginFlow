//
//  CGPickerViewController.swift
//  Community
//
//  Created by Blake Anderson on 12/17/19.
//  Copyright © 2019 Blake Anderson. All rights reserved.
//

import UIKit
import Firebase

class CGPickerViewController: UIViewController {
    
    var selectedCard: Int?
    var image: UIImage!
    var cgPassword: String = "password"
    
    let emailCard = EmailCard()
    let joinButton = UIButton(frame: CGRect(x: -385, y: 747, width: 360, height: 48))
    let searchBar = UISearchBar()
    
    let cgCollectionView: UICollectionView = {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 125, left: 25, bottom: 125, right: 25)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CGCard.self, forCellWithReuseIdentifier: "card")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let cgNames: [String] = {
        var names: [String] = []
        
        for cg in cgData {
            names.append(cg.name)
        }
        
        return names
    }()
    
    init(selectedImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.image = selectedImage
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.view.backgroundColor = lightGrey
        cgCollectionView.backgroundColor = .clear
        cgCollectionView.delegate = self
        cgCollectionView.dataSource = self
        
        self.view.addSubview(cgCollectionView)
        self.view.addSubview(emailCard)
        self.emailCard.isHidden = true
        self.view.sendSubviewToBack(emailCard)
        
        joinButton.titleLabel?.text = "JOIN CG"
        joinButton.backgroundColor = secondaryColor
        joinButton.layer.cornerRadius = 20
        joinButton.layer.shadowColor = primaryColor.cgColor
        joinButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        joinButton.layer.shadowRadius = 3.0
        joinButton.layer.shadowOpacity = 0.5
        joinButton.layer.masksToBounds = false
        joinButton.addTarget(self, action: #selector(join), for: .touchDown)
        self.view.addSubview(joinButton)
        
        searchBar.delegate = self
        searchBar.tintColor = primaryColor
        searchBar.placeholder = "Find your CG"
        searchBar.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.maxX, height: 44)
    
        self.navigationItem.titleView = searchBar
        self.view.bringSubviewToFront(searchBar)
    }

    @objc func join(_ sender: UIButton) {
        
        let data = Data(self.image.jpegData(compressionQuality: 0.5)!)
        
        let profPicStor = Storage.storage().reference().child("profPic")
        let fs = Firestore.firestore().collection("communityGroup").document(cgNames[selectedCard!]).collection("users").document("nameAndPic")
        
        let alertController = UIAlertController(title: cgNames[selectedCard!], message: "Please enter password:", preferredStyle: .alert)
        
        alertController.addTextField { (passwordField) in
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "Password"
        }
        alertController.addAction(UIAlertAction(title: "Join", style: .default, handler: { (action) in
            
            let password = alertController.textFields![0]
            
            if password.text == self.cgPassword {
                
                let db = Database.database().reference().child("users")
                let user = Auth.auth().currentUser
                
                db.child(user!.uid).setValue(["cgPicked": 1, "cg": self.cgNames[self.selectedCard!]])
                
                let task = profPicStor.child(user!.uid).putData(data, metadata: nil) { (metadata, error) in
                    
                    profPicStor.child(user!.uid).downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("uh oh")
                            print(error!.localizedDescription)
                            return
                        }
                        
                        print(user!.displayName!)
                        print(downloadURL)
                        let userData: [String: Any] = [user!.displayName!: downloadURL.absoluteString]
                        fs.setData(userData, merge: true)
                        
                        let request = user!.createProfileChangeRequest()
                        request.photoURL = downloadURL
                        request.commitChanges { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                task.observe(.success) { (storSnapshot) in
                    print("Uploaded pic")
                }
            } else {
                self.present(alertController, animated: true) {
                    alertController.textFields![0].shake()
                }

            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
    
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        sender.pulse()
        
    }

}

extension CGPickerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 577)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CGCard
        let cg = cgData[indexPath.row]
        
        cell.avatarImage.image = ImageStore.shared.image(name: cg.imageName)
        cell.locationLabel.text = cg.name
        cell.updateMapView(coordinates: cg.locationCoordinate)
        cell.nameLabel.text = cg.shepards
        cell.updateTime(time: cg.day)
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = collectionView.cellForItem(at: indexPath) as! CGCard
        let cg = cgData[indexPath.row]
        
        self.searchBar.resignFirstResponder()
        
        if selectedCard != indexPath.row {
            self.selectedCard = indexPath.row
            collectionView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.25) {
                card.frame = card.frame.offsetBy(dx: 0, dy: -100)
            }
            UIView.animate(withDuration: 0.25) {
                self.emailCard.frame = self.emailCard.frame.offsetBy(dx: 0, dy: 100)
                self.emailCard.isHidden = false
                self.emailCard.updateEmail(email: cg.contact)
            }
            UIView.animate(withDuration: 0.25) {
                self.joinButton.frame = self.joinButton.frame.offsetBy(dx: 410, dy: 0)
                self.joinButton.setTitle("Join " + cg.name + " CG", for: .normal)
            }
        } else {
            self.selectedCard = nil
            collectionView.isScrollEnabled = true
            
            UIView.animate(withDuration: 0.25, animations: {
                card.frame = card.frame.offsetBy(dx: 0, dy: 100)
                self.emailCard.frame = self.emailCard.frame.offsetBy(dx: 0, dy: -100)
            }) { (complete) in
                UIView.animate(withDuration: 0.25) {
                    self.emailCard.isHidden = true
                }
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.joinButton.frame = self.joinButton.frame.offsetBy(dx: 410, dy: 0)
            }) { (complete) in
                self.joinButton.resetJoinButton()
            }
        }
    }
}

extension CGPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        var element: Int?
        
        for name in cgNames {
            if name.lowercased().contains(searchText.lowercased()) {
                element = cgNames.firstIndex(of: name)
            }
        }
        
        let index = IndexPath.init(row:  element ?? 0, section: 0)
        self.cgCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
}

extension UISearchBar {
    func resetPoition() {
        self.frame = CGRect(x: -UIScreen.main.bounds.maxX, y: 40, width: UIScreen.main.bounds.maxX, height: 44)
    }
}

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment - 25, y: proposedContentOffset.y)
    }
}

extension UIButton {
    func resetJoinButton() {
        self.frame =  CGRect(x: -385, y: 747, width: 360, height: 48)
    }
}

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
