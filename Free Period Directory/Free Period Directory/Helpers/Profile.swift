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

class UserProfile {
    
    var userUID: String = ""
    
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
                completion(document.get("free2") as? String ?? "BOB")
            }
        }
    }
}

