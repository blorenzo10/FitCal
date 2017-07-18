////
////  SocialViewController.swift
////  FitCal
////
////  Created by Natalia Consonni on 8/7/17.
////  Copyright © 2017 Bruno Lorenzo. All rights reserved.
////
//
//import UIKit
//import Firebase
//import ACProgressHUD_Swift
//
//class SocialViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    var userList: [User] = []
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let progressHUD = self.initializeProgress(message: "Getting data of users..")
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
//            let users = snapshot.value as! NSDictionary
//            
//            for (key, value) in users {
//                let uid = key as! String
//                let data = value as! NSDictionary
//                let userInfo = data["UserInfo"] as! NSDictionary
//         
//                if !User.instance.userIsFollower(id: uid) && User.instance.uid != uid {
//                    
//                    let storage = FIRStorage.storage()
//                    let storageRef = storage.reference(forURL: "gs://fitnut-fa15d.appspot.com")
//                    let profileImagePath = "images/Profile_" + (uid) + ".jpg"
//                    let pathReference = storageRef.child(profileImagePath)
//                    
//                    pathReference.downloadURL { (URL, error) in
//                        if error != nil {
//                            print(error.debugDescription)
//                        } else {
//                            
//                            let user = User(userInfo["FirstName"] as! String, userInfo["LastName"] as! String, uid, URL!)
//                            self.userList.append(user)
//                            
//                            self.collectionView.reloadData()
//                        }
//                    }
//                }
//            }
//            
//            progressHUD.hideHUD()
//            self.collectionView.reloadData()
//        })
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // ++ Data source protocol
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.userList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! SocialCell
//        
//        let url = self.userList[indexPath.row].urlImage!
//        let dataImage = NSData(contentsOf: url)
//
//        cell.userNameLabel.text = self.userList[indexPath.row].firstName + " " + self.userList[indexPath.row].lastName
//        cell.followButton.addTarget(self, action: #selector(follow(_:)) , for: .touchUpInside)
//        cell.imageView.image  = UIImage(data: dataImage! as Data)
//        
//        return cell
//    }
//    
//    func follow(_ sender: UIButton) {
//       
//        if let cell = sender.superview?.superview  as? SocialCell {
//            let indexPath = self.collectionView.indexPath(for: cell)
//            let row = indexPath?.row
//            User.instance.addFollower(User(self.userList[row!].firstName, self.userList[row!].lastName, self.userList[row!].uid,self.userList[row!].urlImage!))
//            
//            var ref: FIRDatabaseReference!
//            ref = FIRDatabase.database().reference()
//            
//            let data: [String: Any] = [self.userList[row!].uid: self.userList[row!].uid]
//            ref.child("Users").child(User.instance.uid).child("Followers").updateChildValues(data)
//            
//            self.userList.remove(at: row!)
//            self.collectionView.deleteItems(at: [indexPath!])
//            self.collectionView.reloadData()
//        }
//    }
//    // --
//    
//    // ++ uicollectionviewflowlayout delegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = self.view.frame.width / 4
//        return CGSize(width: size, height: collectionView.contentSize.height)
//    }
//    // --
//    
//    func initializeProgress(message msg: String) -> ACProgressHUD {
//        let progressView = ACProgressHUD.shared
//        progressView.progressText = msg
//        progressView.showHUD()
//        return progressView
//    }
//
//}
