//
//  Home ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/21/21.
//

import UIKit
import Firebase
import FirebaseAuth

class Home_ViewController: UIViewController {

    @IBOutlet weak var welcome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call the user uid to set the value of his/her/their frees
        // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
        guard let user = Auth.auth().currentUser else { return }
        let userUID = user.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userUID)
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let firstName = document.get("firstname") as! String
                let lastName = document.get("lastname") as! String
                let free1 = document.get("free1") as! String
                let free2 = document.get("free2") as! String
                self.welcome.text = "Welcome \(firstName) \(lastName)! You have \(free1) and \(free2) frees"
            } else {
                print("Document does not exist")
            }
        }
        
        
        self.view.addSubview(welcome)

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
