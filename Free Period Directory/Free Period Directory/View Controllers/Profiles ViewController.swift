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
    
    // create an array of User Profile objects
    var userProfiles: [UserProfile] = []
    // create an array of stackViews (the profiles themselves)
    var profileStacks: [UIStackView] = []
    // this array is used to get all of the data from the database
    var data: [dataType] = []
    // this array will contain the data (users) that match the keyword search
    var filteredData: [dataType] = []
    // this array will contain the user ids of the users that match the keyword search
    var filteredUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get all data from database
        self.getData()
        
        // add scroll functionality
        view.addSubview(scrollView)
        // create a vertical stack in the scrollView to help arrange the profiles
        self.scrollView.addSubview(vertStack)
        
        // set up vertical stack
        self.vertStack.translatesAutoresizingMaskIntoConstraints = false
        self.vertStack.spacing = 10
        self.vertStack.alignment = .fill
        self.vertStack.distribution = .fillEqually
        
        // get all uids
        self.getDocNames() { (data) in
            let allUsers = data
            var i = 0
            // loop that creates all the profiles and adds them to the vertical stack
            while i < allUsers.count {
                let userProfile = UserProfile(uid: allUsers[i])
                self.userProfiles.append(userProfile)
                let profile = userProfile.createProfile(view: self.vertStack)
                self.profileStacks.append(profile)
                self.vertStack.addArrangedSubview(profile)
                i = i + 1
            }
            // set size of the scrollView
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((allUsers.count) * 440))
        }
    }

    @IBAction func searchPressed(_ sender: Any) {
        // remove everything from the vertical stack
        self.removeStackViews()
        
        // make the searched text uniform
        var searchedText = searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        searchedText = searchedText.lowercased()
        
        // make sure these two arrays are empty each time the search button is pressed
        filteredData.removeAll()
        filteredUsers.removeAll()

        // if anything in data includes the searched text, add to the filteredData array
        for i in data {
            if i.allText.lowercased().contains(searchedText){
                filteredData.append(i)
            }
        }
        
        // create profiles for the filteredData users and add to the vertical stack
        for i in filteredData {
            let userProfile = UserProfile(uid: i.id)
            let profile = userProfile.createProfile(view: self.vertStack)
            self.vertStack.addArrangedSubview(profile)
            filteredUsers.append(i.id)
        }
        // resize the scrollView
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((filteredUsers.count) * 440))

        // Send alert if no profiles match the keyword the user entered
        if filteredData.count == 0 {
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "No profiles match your keyword", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    // function that gets all the uids from the database except the current user's
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
    
    // Gets the userID of the current user
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
    
    // Gets the data from the database and organizes it
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
                    // allText will be used to determine if the keyword can be found in a user's profile
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
    
    // removes all views from a stack
    func removeStackViews() {
        let profileViews = vertStack.subviews
        for subUIView in profileViews {
            subUIView.removeFromSuperview()
        }
    }
}
