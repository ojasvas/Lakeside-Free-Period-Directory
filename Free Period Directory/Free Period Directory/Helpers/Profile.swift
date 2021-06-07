//
//  Profile.swift
//  Free Period Directory
//
//  Created by Student on 4/2/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

// https://stackoverflow.com/questions/33927914/how-can-i-set-the-cornerradius-of-a-uistackview
extension UIStackView {
    func customize(backgroundColor: UIColor = .gray, radiusSize: CGFloat = 20) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor.withAlphaComponent(0.2)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

class UserProfile {

    // set up variables
    var userUID: String = ""
    var name = UILabel()
    var free1 = UILabel()
    var free2 = UILabel()
    let maxCourses = 7
    var coursesArray: [String] = []
    var course1 = UILabel()
    var course2 = UILabel()
    var course3 = UILabel()
    var course4 = UILabel()
    var course5 = UILabel()
    var course6 = UILabel()
    var course7 = UILabel()
    var studySpot = UILabel()
    var interest1 = UILabel()
    var interest2 = UILabel()
    var interest3 = UILabel()
    let seeMoreButton = UIButton(type: .system)
    var buttonTag = 0
    
    init (uid: String) {
        self.userUID = uid
    }
    
    let db = Firestore.firestore()
    
    // GETTER METHODS
    // 
    
    // understanding how to return the values of asynchronous functions
    // https://dev-wd.github.io/swift/escaping-closure/
    func getFirstName(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("firstname") as? String ?? "N/A")
            }
        }
    }
    
    func getLastName(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("lastname") as? String ?? "N/A")
            }
        }
    }
    
    func getFreeOne(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("free1") as? String ?? "N/A")
            }
        }
    }
    
    func getFreeTwo(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("free2") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseOne(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course1") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseTwo(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course2") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseThree(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course3") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseFour(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course4") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseFive(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course5") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseSix(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course6") as? String ?? "N/A")
            }
        }
    }
    
    func getCourseSeven(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course7") as? String ?? "N/A")
            }
        }
    }
    
    func getInterestOne(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("interest1") as? String ?? "N/A")
            }
        }
    }
    
    func getInterestTwo(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("interest2") as? String ?? "N/A")
            }
        }
    }
    
    func getInterestThree(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("interest3") as? String ?? "N/A")
            }
        }
    }

    func getStudySpot(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("favoriteStudySpot") as? String ?? "No Preference")
            } 
        }
    }
    
    // create a stackview for the profile
    func createProfile(view: UIView) -> UIStackView {
        
        // set up vertstack
        let vertStack = UIStackView()
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        vertStack.axis = .vertical
        vertStack.spacing = 20.0
        vertStack.alignment = .fill
        vertStack.distribution = .fillEqually
        vertStack.spacing = UIStackView.spacingUseSystem
        vertStack.isLayoutMarginsRelativeArrangement = true
        vertStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        // customizes vertstack
        vertStack.customize()
        
        // GET ALL INFO
        
        self.getFirstName() { (data) in
            let firstName = data
            self.name.text = "Name: \(firstName) "
        }
        self.getLastName() { (data) in
            let lastName = data
            self.name.text = (self.name.text ?? "") + (lastName)
        }
        vertStack.addArrangedSubview(name)
        name.textAlignment = NSTextAlignment.center
        
        self.getFreeOne() { (data) in
            let freeOne = data
            self.free1.text = "Free One: \(freeOne) "
        }
        vertStack.addArrangedSubview(free1)
        free1.textAlignment = NSTextAlignment.center
        
        self.getFreeTwo() { (data) in
            let freeTwo = data
            self.free2.text = "Free Two: \(freeTwo) "
        }
        vertStack.addArrangedSubview(free2)
        free2.textAlignment = NSTextAlignment.center
        
        self.getCourseOne() { (data) in
            let courseOne = data
            self.course1.text = "Course One: \(courseOne) "
        }
        vertStack.addArrangedSubview(course1)
        course1.textAlignment = NSTextAlignment.center
        
        self.getCourseTwo() { (data) in
            let courseTwo = data
            self.course2.text = "Course Two: \(courseTwo) "
        }
        vertStack.addArrangedSubview(course2)
        course2.textAlignment = NSTextAlignment.center
        
        self.getCourseThree() { (data) in
            let courseThree = data
            self.course3.text = "Course Three: \(courseThree) "
        }
        vertStack.addArrangedSubview(course3)
        course3.textAlignment = NSTextAlignment.center
        
        self.getCourseFour() { (data) in
            let courseFour = data
            self.course4.text = "Course Four: \(courseFour) "
        }
        vertStack.addArrangedSubview(course4)
        course4.textAlignment = NSTextAlignment.center
        
        self.getCourseFive() { (data) in
            let courseFive = data
            self.course5.text = "Course Five: \(courseFive) "
        }
        vertStack.addArrangedSubview(course5)
        course5.textAlignment = NSTextAlignment.center
        
        self.getCourseSix() { (data) in
            let courseSix = data
            self.course6.text = "Course Six: \(courseSix) "
        }
        vertStack.addArrangedSubview(course6)
        course6.textAlignment = NSTextAlignment.center
        
        self.getCourseSeven() { (data) in
            let courseSeven = data
            self.course7.text = "Course Seven: \(courseSeven) "
        }
        vertStack.addArrangedSubview(course7)
        course7.textAlignment = NSTextAlignment.center

        self.getStudySpot() { (data) in
            let studySpot = data
            self.studySpot.text = "Favorite Study Spot: \(studySpot) "
        }
        vertStack.addArrangedSubview(studySpot)
        studySpot.textAlignment = NSTextAlignment.center
        
        self.getInterestOne() { (data) in
            let interestOne = data
            self.interest1.text = "Interest One: \(interestOne) "
        }
        vertStack.addArrangedSubview(interest1)
        interest1.textAlignment = NSTextAlignment.center
        
        self.getInterestTwo() { (data) in
            let interestTwo = data
            self.interest2.text = "Interest Two: \(interestTwo) "
        }
        vertStack.addArrangedSubview(interest2)
        interest2.textAlignment = NSTextAlignment.center
        
        self.getInterestThree() { (data) in
            let interestThree = data
            self.interest3.text = "Interest Three: \(interestThree) "
        }
        vertStack.addArrangedSubview(interest3)
        interest3.textAlignment = NSTextAlignment.center
        
        // add the vertstack to the view (in this case, the scroll view)
        view.addSubview(vertStack)
        
        return vertStack
    }
}

