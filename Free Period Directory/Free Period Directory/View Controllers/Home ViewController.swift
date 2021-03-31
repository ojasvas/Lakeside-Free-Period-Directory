//
//  Home ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/21/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Home_ViewController: UIViewController {

    @IBOutlet weak var welcome: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        signOutCurrentUser()
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        showDeletionAlert()
    }
    
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
                self.welcome.text = "Welcome \(firstName) \(lastName)! Your have \(free1) and \(free2) frees"
            } else {
                print("Document does not exist")
            }
        }
        
        
        self.view.addSubview(welcome)

        // Do any additional setup after loading the view.
    }
    
    func deleteAccount(){
        let user = Auth.auth().currentUser
        //From https://stackoverflow.com/questions/49575903/swift4-delete-user-accounts-from-firebase-authentication-system
        self.deleteUserDocument()
        user?.delete { (error) in
            if error != nil {
            self.errorLabel.text = "Error occurred in account deletion"
            self.errorLabel.alpha = 1
          } else {
            self.goToInitialScreen()
          }
        }
    }
    
    func signOutCurrentUser(){
        do {
            try Auth.auth().signOut()
            self.goToInitialScreen()
        } catch{
            self.errorLabel.text = "Error in signing out"
        }
    }
    
    func getCurrentUserID() -> Any?{
        let user = Auth.auth().currentUser
        let uid = user?.uid
        if(uid != nil){
            let myUid = uid!
            return myUid
        }
        else{
            return nil
        }
    }
    
    func deleteUserDocument(){
        let myUid = getCurrentUserID()
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: myUid!).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    db.collection("users").document(document.documentID).delete()
                }
            }
        }
    }
    
    func showDeletionAlert(){
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("tapped cancel")}))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in self.deleteAccount()}))
        present(alert, animated: true)
    }
    
    func showLogoutAlert(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout of this account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("tapped cancel")}))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in self.signOutCurrentUser()}))
        present(alert, animated: true)
    }
    
    func goToInitialScreen() {
        
        let viewController =
            storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.initialViewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
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
