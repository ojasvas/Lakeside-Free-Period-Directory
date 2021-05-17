//
//  Profiles ViewController.swift
//  Free Period Directory
//
//  Created by Student on 4/2/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Profiles_ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vertStack: UIStackView!
    
    var userProfiles: [UserProfile] = []
    var profileStacks: [UIStackView] = []
    let maxCourses = 7
    var buttonTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        self.scrollView.addSubview(vertStack)
        
        self.vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.vertStack.spacing = 10
        self.vertStack.alignment = .fill
        self.vertStack.distribution = .fillEqually
        
        self.scrollView.contentSize = CGSize(width: view.frame.size.width, height: 4000)
        
        self.getDocNames() { (data) in
            let allUsers = data
            var i = 0
            while i < allUsers.count {
                let userProfile = UserProfile(uid: allUsers[i])
                self.userProfiles.append(userProfile)
                let profile = userProfile.createProfile(view: self.vertStack)
                self.profileStacks.append(profile)
                self.vertStack.addArrangedSubview(profile)
                i = i + 1
            }
        }
    }

    func getDocNames(completion: @escaping (Array<String>) -> Void) {
        var docIDArray: [String] = []
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let uid = document.documentID
                    let myUid = self.getCurrentUserID() as! String
                    if myUid != uid {
                        docIDArray.append(uid)
                    }
                }
                completion(docIDArray)
            }
        }
    }
    
    //Gets the userID of the current user
    func getCurrentUserID() -> Any? {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        if uid != nil {
            let myUid = uid!
            return myUid
        }
        else {
            return nil
        }
    }
    

}
