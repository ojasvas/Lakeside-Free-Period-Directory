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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        self.scrollView.addSubview(vertStack)
        
        self.vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.vertStack.spacing = 10
        self.vertStack.alignment = .fill
        self.vertStack.distribution = .fillEqually
        
        
        self.scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2200)
        
        getDocNames() { (data) in
            let allUsers = data
            var i = 0
            while i < allUsers.count {
                let userProfile = UserProfile(uid: allUsers[i])
                let profile = userProfile.createProfile(view: self.vertStack)
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
                    docIDArray.append(uid)
                }
                completion(docIDArray)
            }
        }
    }

}
