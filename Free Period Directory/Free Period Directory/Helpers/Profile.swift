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
    var frees = UILabel()
//    var courses: String
//    var studySpot: String
    
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
    
//    func getCourseOne(completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("Course 1") as? String ?? "error")
//            }
//        }
//    }
//
//    func getCourseTwo(completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("Course 2") as? String ?? "error")
//            }
//        }
//    }
//
//    func getCourseThree(completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("Course 3") as? String ?? "error")
//            }
//        }
//    }
//
//    func getCourseFour(completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("Course 4") as? String ?? "error")
//            }
//        }
//    }
//
//    func getStudySpot(completion: @escaping (String) -> Void) {
//        let ref = db.collection("users").document(userUID)
//        ref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                completion(document.get("Favorite Study Spot") as? String ?? "error")
//            }
//        }
//    }
    
    func createProfile(view: UIView) -> UIStackView {
        let vertStack = UIStackView()
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        vertStack.axis = .vertical
        vertStack.spacing = 20.0
        vertStack.alignment = .fill
        vertStack.distribution = .fillEqually
        
        view.addSubview(vertStack)
        
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
            self.frees.text = "Frees: \(freeOne) "
        }
        self.getFreeTwo() { (data) in
            let freeTwo = data
            self.frees.text = (self.frees.text ?? "") + (freeTwo)
        }
        vertStack.addArrangedSubview(name)
        name.textAlignment = NSTextAlignment.center
        
        view.addSubview(vertStack)
        
        return vertStack
    }
}

