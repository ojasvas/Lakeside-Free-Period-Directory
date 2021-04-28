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
        errorLabel.alpha = 0
        // call the user uid to set the value of his/her/their frees
        // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
        guard let user = Auth.auth().currentUser else { return }
        let userUID = user.uid
        let testUser = UserProfile(uid: userUID)
        
        testUser.getFirstName() { (data) in
            let firstName = data
            self.welcome.text = "Welcome \(firstName) "
        }
        testUser.getLastName() { (data) in
            let lastName = data
            self.welcome.text = (self.welcome.text ?? "") + (lastName) + "! You have "
        }
        testUser.getFreeOne() { (data) in
            let free1 = data
            self.welcome.text = (self.welcome.text ?? "") + (free1) + " and "
        }
        testUser.getFreeTwo() { (data) in
            let free2 = data
            self.welcome.text = (self.welcome.text ?? "") + (free2) + " frees"
        }
        
        self.view.addSubview(welcome)
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
    }
    
    //Deletes account from firebase authentication database
    func deleteAccount(){
        let user = Auth.auth().currentUser
        //From https://stackoverflow.com/questions/49575903/swift4-delete-user-accounts-from-firebase-authentication-system
        self.deleteUserDocument()
        user?.delete { (error) in
            if error != nil {
            self.showError("Error occurred in account deletion")
            self.errorLabel.alpha = 1
          } else {
            self.goToInitialScreen()
          }
        }
    }
    
    //Signs out the current user
    func signOutCurrentUser(){
        do {
            try Auth.auth().signOut()
            self.goToInitialScreen()
        } catch{
            self.showError("Error in signing out")
        }
    }
    
    //Gets the userID of the current user
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
    
    //Deletes the user account from Firestore database "users"
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
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //Alerts the user to confirm that they want to delete their account
    func showDeletionAlert(){
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("tapped cancel")}))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in self.deleteAccount()}))
        present(alert, animated: true)
    }
    
    //Alerts the user to confirm that they would like to log out
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
