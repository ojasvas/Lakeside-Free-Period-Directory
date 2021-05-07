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
//                self.setUpMoreButton(indexNum: i)
                let profile = userProfile.createProfile(view: self.vertStack)
                self.profileStacks.append(profile)
                self.vertStack.addArrangedSubview(profile)
                i = i + 1
            }
        }
    }
//
//    func setUpMoreButton(indexNum: Int) {
//        userProfiles[indexNum].seeMoreButton.tag = indexNum
//        userProfiles[indexNum].seeMoreButton.addTarget(self, action: #selector(self.moreButtonClicked(sender:)), for: .touchUpInside)
//    }
//
//    @objc func moreButtonClicked(sender: UIButton) {
//        buttonTag = sender.tag
//        self.goToExpandedProfileScreen()
//
//    }
    
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

//    func addToStack(senderTag: Int) {
//        if (userProfiles[senderTag].courses[0] != "error") {
//            userProfiles[senderTag].course1.text = userProfiles[senderTag].courses[0]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course1)
//            userProfiles[senderTag].course1.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[1] != "error") {
//            userProfiles[senderTag].course2.text = userProfiles[senderTag].courses[1]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course2)
//            userProfiles[senderTag].course2.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[2] != "error") {
//            userProfiles[senderTag].course3.text = userProfiles[senderTag].courses[2]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course3)
//            userProfiles[senderTag].course3.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[3] != "error") {
//            userProfiles[senderTag].course4.text = userProfiles[senderTag].courses[3]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course4)
//            userProfiles[senderTag].course4.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[4] != "error") {
//            userProfiles[senderTag].course5.text = userProfiles[senderTag].courses[4]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course5)
//            userProfiles[senderTag].course5.textAlignment = NSTextAlignment.center
//        } else {
//            userProfiles[senderTag].course5.text = "N/A"
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course5)
//            userProfiles[senderTag].course5.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[5] != "error") {
//            userProfiles[senderTag].course6.text = userProfiles[senderTag].courses[5]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course6)
//            userProfiles[senderTag].course6.textAlignment = NSTextAlignment.center
//        } else {
//            userProfiles[senderTag].course6.text = "N/A"
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course5)
//            userProfiles[senderTag].course6.textAlignment = NSTextAlignment.center
//        }
//        if (userProfiles[senderTag].courses[6] != "error") {
//            userProfiles[senderTag].course7.text = userProfiles[senderTag].courses[6]
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course7)
//            userProfiles[senderTag].course7.textAlignment = NSTextAlignment.center
//        } else {
//            userProfiles[senderTag].course7.text = "N/A"
//            profileStacks[senderTag].addArrangedSubview(userProfiles[senderTag].course5)
//            userProfiles[senderTag].course7.textAlignment = NSTextAlignment.center
//        }
//    }
//
//    func goToExpandedProfileScreen() {
//
//        let expandedProfileViewController =
//            storyboard?.instantiateViewController(identifier:
//            Constants.Storyboard.expandedProfileViewController) as?
//            Expanded_Profile_ViewController
//
//        view.window?.rootViewController = expandedProfileViewController
//        view.window?.makeKeyAndVisible()
//
//    }
}
