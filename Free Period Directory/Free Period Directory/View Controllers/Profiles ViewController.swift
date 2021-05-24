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

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    var userProfiles: [UserProfile] = []
    var profileStacks: [UIStackView] = []
    var data: [dataType] = []
    var filteredData: [dataType] = []
    var filteredProfiles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
        view.addSubview(scrollView)
        self.scrollView.addSubview(vertStack)
        
        self.vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.vertStack.spacing = 10
        self.vertStack.alignment = .fill
        self.vertStack.distribution = .fillEqually
        
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
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((allUsers.count + 1) * 440))
        }
    }

    @IBAction func searchPressed(_ sender: Any) {
        self.removeStackViews()
        var searchedText = searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        searchedText = searchedText.lowercased()
        filteredData.removeAll()
        filteredProfiles.removeAll()

        for i in data {
            if i.allText.lowercased().contains(searchedText){
                filteredData.append(i)
            }
        }
//        print(filteredData)
        for i in filteredData {
            let userProfile = UserProfile(uid: i.id)
            let profile = userProfile.createProfile(view: self.vertStack)
            self.vertStack.addArrangedSubview(profile)
            filteredProfiles.append(i.id)
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((filteredProfiles.count) * 440))
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
    
    //Gets the data from the entire courses database and appends it to the courses and data arrays
    func getData() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments{[weak self] snap, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else {
                guard let snapshot = snap else {return}
                for document in snapshot.documents{
                    let i = document.data()
                    let id = document.documentID
                    let firstName = i["firstname"] as! String
                    let lastName = i["lastname"] as! String
                    let courseOne = i["course1"] as! String
                    let courseTwo = i["course2"] as! String
                    let courseThree = i["course3"] as! String
                    let courseFour = i["course4"] as! String
                    let courseFive = i["course5"] as! String
                    let courseSix = i["course6"] as! String
                    let courseSeven = i["course7"] as! String
                    let freeOne = i["free1"] as! String
                    let freeTwo = i["free2"] as! String
                    let interestOne = i["interest1"] as! String
                    let interestTwo = i["interest2"] as! String
                    let interestThree = i["interest3"] as! String
                    let studySpot = i["favoriteStudySpot"] as! String
                    let allText = ("\(firstName) \(lastName) \(courseOne) \(courseTwo) \(courseThree) \(courseFour) \(courseFive) \(courseSix) \(courseSeven) \(freeOne) \(freeTwo) \(interestOne) \(interestTwo) \(interestTwo) \(studySpot)")
                    self?.data.append(dataType(id: id, firstName: firstName, lastName: lastName, courseOne: courseOne, courseTwo: courseTwo, courseThree: courseThree, courseFour: courseFour, courseFive: courseFive, courseSix: courseSix, courseSeven: courseSeven, freeOne: freeOne, freeTwo: freeTwo, interestOne: interestOne, interstTwo: interestTwo, interestThree: interestThree, studySpot: studySpot, allText: allText))
                }
            }
        }
    }
    
    struct dataType: Identifiable {
        
        var id: String
        var firstName: String
        var lastName: String
        var courseOne: String
        var courseTwo: String
        var courseThree: String
        var courseFour: String
        var courseFive: String
        var courseSix: String
        var courseSeven: String
        var freeOne: String
        var freeTwo: String
        var interestOne: String
        var interstTwo: String
        var interestThree: String
        var studySpot: String
        var allText: String
    }
    
    func removeStackViews() {
        let profileViews = vertStack.subviews
        for subUIView in profileViews {
            subUIView.removeFromSuperview()
        }
    }
}
