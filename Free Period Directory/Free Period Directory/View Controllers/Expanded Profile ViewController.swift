//
//  Expanded Profile ViewController.swift
//  Free Period Directory
//
//  Created by Student on 5/3/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Expanded_Profile_ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTag = Profiles_ViewController.init().buttonTag
        
        self.scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2200)
        
        self.getDocNames() { (data) in
            let allUsers = data
            let userProfile = UserProfile(uid: allUsers[buttonTag])
            let profile = userProfile.createProfile(view: self.scrollView)
            self.scrollView.addSubview(profile)
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
                    docIDArray.append(uid)
                }
                completion(docIDArray)
            }
        }
    }
}
