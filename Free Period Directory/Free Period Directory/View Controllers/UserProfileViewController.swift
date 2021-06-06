//
//  UserProfileViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/17/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserProfileViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var userFirstName: UILabel!
    
    @IBOutlet weak var userLastName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userFree1: UILabel!
    
    @IBOutlet weak var userFree2: UILabel!
    
    @IBOutlet weak var userFree3: UILabel!
    
    @IBOutlet weak var userFavoriteStudySpot: UILabel!
    
    @IBOutlet weak var userCourse1: UILabel!
    
    @IBOutlet weak var userCourse2: UILabel!
    
    @IBOutlet weak var userCourse3: UILabel!
    
    @IBOutlet weak var userCourse4: UILabel!
    
    @IBOutlet weak var userCourse5: UILabel!
    
    @IBOutlet weak var userCourse6: UILabel!
    
    @IBOutlet weak var userCourse7: UILabel!
    
    @IBOutlet weak var userInterest1: UILabel!
    
    @IBOutlet weak var userInterest2: UILabel!
    
    @IBOutlet weak var userInterest3: UILabel!
    
    var freesLabelsArray = [UILabel]()
    
    var coursesLabelsArray = [UILabel]()
    
    var interestsLabelsArray = [UILabel]()
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        goToHomeScreen()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        signOutCurrentUser()
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        showDeletionAlert()
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        goToEditProfileScreen()
    }
    
    @IBAction func editFreesButtonTapped(_ sender: Any) {
    }
    @IBAction func editCoursesButtonTapped(_ sender: Any) {
    }
    @IBAction func EditStudySpotButtonTapped(_ sender: Any) {
    }
    @IBAction func EditInterestsButtonTapped(_ sender: Any) {
    }
    override func viewDidLoad() {
        errorLabel.alpha = 0
        freesLabelsArray = [userFree1,userFree2,userFree3]
        coursesLabelsArray = [userCourse1,userCourse2,userCourse3,userCourse4,userCourse5, userCourse6, userCourse7]
        interestsLabelsArray = [userInterest1, userInterest2, userInterest3]
        getUserData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getUserData(){
        guard let user = Auth.auth().currentUser else {return}
        let userUID = user.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("firstname") != nil{
                    self.userFirstName.text = (document.get("firstname") as! String)
                }
                else{
                    self.userFirstName.text = "N/A"
                }
                if document.get("lastname") != nil{
                    self.userLastName.text = (document.get("lastname") as! String)
                }
                else{
                    self.userLastName.text = "N/A"
                }
                if user.email != nil{
                    self.userEmail.text = user.email
                }
                else{
                    self.userEmail.text = "N/A"
                }
                
                if document.get("favoriteStudySpot") != nil{
                    self.userFavoriteStudySpot.text = (document.get("favoriteStudySpot") as! String)
                }
                else{
                    self.userFavoriteStudySpot.text = "N/A"
                }
                
                var i = 1
                while i < 4{
                    if document.get("free"+String(i)) != nil{
                        self.freesLabelsArray[i-1].text = (document.get("free"+String(i)) as! String)
                    }
                    else{
                        self.freesLabelsArray[i-1].text = "N/A"
                    }
                    i+=1
                }
                var j = 1
                while j < 8{
                    if document.get("course"+String(j)) != nil{
                        self.coursesLabelsArray[j-1].text = (document.get("course"+String(j)) as! String)
                    }
                    else{
                        self.coursesLabelsArray[j-1].text = "N/A"
                    }
                    j+=1
                }
                var k = 1
                while k < 4{
                    if document.get("interest"+String(k)) != nil{
                        self.interestsLabelsArray[k-1].text = (document.get("interest"+String(k)) as! String)
                    }
                    else{
                        self.interestsLabelsArray[k-1].text = "N/A"
                    }
                    k+=1
                }
            }
        }
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
    
    func goToHomeScreen(){
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? Home_ViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToEditProfileScreen(){
        let userProfileIsEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.userProfileIsEditingViewController) as? UserProfileIsEditingViewController
        view.window?.rootViewController = userProfileIsEditingViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToEditNameEmailScreen(){
        let nameEmailIsEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.nameEmailIsEditingViewController) as? Name_and_Email_IsEditing_ViewController
        view.window?.rootViewController = nameEmailIsEditingViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToEditFreesScreen(){
        let freesIsEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.freesIsEditingViewController) as? Frees_IsEditing_ViewController
        view.window?.rootViewController = freesIsEditingViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToEditStudySpotScreen(){
        let studySpotIsEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.studySpotIsEditingViewController) as? Study_Spot_IsEditing_ViewController
        view.window?.rootViewController = studySpotIsEditingViewController
        view.window?.makeKeyAndVisible()
    }

    func goToEditCoursesScreen(){
        let coursesIseEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.coursesIseEditingViewController) as? Courses_IsEditing_ViewController
        view.window?.rootViewController = coursesIseEditingViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToEditInterestsScreen(){
        let interestsIsEditingViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.interestsIsEditingViewController) as? Interests_IsEditing_ViewController
        view.window?.rootViewController = interestsIsEditingViewController
        view.window?.makeKeyAndVisible()
    }
}
