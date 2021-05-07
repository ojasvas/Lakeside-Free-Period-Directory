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
    let seeMoreButton = UIButton(type: .system)
    var buttonTag = 0
    
    init (uid: String) {
        self.userUID = uid
    }

    let db = Firestore.firestore()
    
    // understanding how to return the values of asynchronous functions
    // https://dev-wd.github.io/swift/escaping-closure/
    func getFirstName(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("firstname") as? String ?? "error")
            }
        }
    }
    
    func getLastName(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("lastname") as? String ?? "error")
            }
        }
    }
    
    func getFreeOne(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("free1") as? String ?? "error")
            }
        }
    }
    
    func getFreeTwo(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("free2") as? String ?? "error")
            }
        }
    }
    
    func getCourseOne(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course1") as? String ?? "error")
            }
        }
    }
    
    func getCourseTwo(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course2") as? String ?? "error")
            }
        }
    }
    
    func getCourseThree(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course3") as? String ?? "error")
            }
        }
    }
    
    func getCourseFour(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course4") as? String ?? "error")
            }
        }
    }
    
    func getCourseFive(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course5") as? String ?? "error")
            }
        }
    }
    
    func getCourseSix(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course6") as? String ?? "error")
            }
        }
    }
    
    func getCourseSeven(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("course7") as? String ?? "error")
            }
        }
    }
    
//    func getCourse(courseNum: String, completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("course\(courseNum)") as? String ?? "error")
//            }
//        }
//    }

    func getStudySpot(completion: @escaping (String) -> Void) {
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(document.get("favoriteStudySpot") as? String ?? "error")
            }
        }
    }
    
    func createProfile(view: UIView) -> UIStackView {
        
        let vertStack = UIStackView()
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        vertStack.axis = .vertical
        vertStack.spacing = 20.0
        vertStack.alignment = .fill
        vertStack.distribution = .fillEqually
        vertStack.spacing = UIStackView.spacingUseSystem
        vertStack.isLayoutMarginsRelativeArrangement = true
        vertStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)


        vertStack.customize()
        
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
            if freeTwo == "" {
                self.free2.text = "Free Two: N/A"
            } else {
                self.free2.text = "Free Two: \(freeTwo) "
            }
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
            if courseFive == "error" {
                self.course5.text = "Course Five: N/A"
            } else {
                self.course5.text = "Course Five: \(courseFive) "
            }
        }
        vertStack.addArrangedSubview(course5)
        course5.textAlignment = NSTextAlignment.center
        
        self.getCourseSix() { (data) in
            let courseSix = data
            if courseSix == "error" {
                self.course6.text = "Course Six: N/A"
            } else {
                self.course6.text = "Course Six: \(courseSix) "
            }
        }
        vertStack.addArrangedSubview(course6)
        course6.textAlignment = NSTextAlignment.center
        
        self.getCourseSeven() { (data) in
            let courseSeven = data
            if courseSeven == "error" {
                self.course7.text = "Course Seven: N/A"
            } else {
                self.course7.text = "Course Seven: \(courseSeven) "
            }
        }
        vertStack.addArrangedSubview(course7)
        course7.textAlignment = NSTextAlignment.center

        
        self.getStudySpot() { (data) in
            let studySpot = data
            self.studySpot.text = "Favorite Study Spot: \(studySpot) "
        }
        vertStack.addArrangedSubview(studySpot)
        studySpot.textAlignment = NSTextAlignment.center
        
//        // add courses to the vertical stack
//        var j = 1
//        while j <= coursesArray.count {
//            self.courses.text = (self.courses.text ?? "") + "Course \(j): \(coursesArray[j - 1])"
//            print(coursesArray[j - 1])
//            j = j + 1
//        }
//        self.courses.lineBreakMode = .byWordWrapping
//        self.courses.numberOfLines = 0
//        vertStack.addArrangedSubview(courses)
//        courses.textAlignment = NSTextAlignment.center
//
//        self.initializeMoreButton(stack: vertStack)

        view.addSubview(vertStack)
        
        return vertStack
    }
//
//    func initializeMoreButton(stack: UIStackView) {
//        self.seeMoreButton.setTitle("See More", for: .normal)
//        self.seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
//        stack.addArrangedSubview(seeMoreButton)
//        self.seeMoreButton.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive = true
//    }
//
    func addCourse(course: String) {
        self.coursesArray.append(course)
    }


    
}

