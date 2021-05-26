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
    
    
    @IBAction func profilesButtonTapped(_ sender: Any) {
        goToProfilesScreen()
    }
    
    @IBAction func yourProfileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
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
            self.welcome.text = "Welcome \(firstName.capitalized) "
        }
        testUser.getLastName() { (data) in
            let lastName = data
            self.welcome.text = (self.welcome.text ?? "") + (lastName.capitalized) + "! You have "
        }
        testUser.getFreeOne() { (data) in
            let free1 = data
            self.welcome.text = (self.welcome.text ?? "") + (free1)
        }
        testUser.getFreeTwo() { (data) in
            let free2 = data
            if free2 == "N/A" {
                self.welcome.text = (self.welcome.text ?? "") + " free"
            } else {
                self.welcome.text = (self.welcome.text ?? "") + " and " + (free2) + " frees"
            }
        }
        
        self.view.addSubview(welcome)
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
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
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
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
    
    func goToProfilesScreen() {
        let profilesViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.profilesViewController) as? Profiles_ViewController
        view.window?.rootViewController = profilesViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToUserProfileScreen() {
        let userProfileViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.userProfileViewController) as? UserProfileViewController
        view.window?.rootViewController = userProfileViewController
        view.window?.makeKeyAndVisible()
    }

}
