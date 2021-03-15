//
//  Signup ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/21/21.
//

import UIKit
import Firebase
import FirebaseAuth


class Signup_ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
    }
    
    // Check the field and validate that the data is correct.
    // If everything is correct, nil is returned. Otherwise and error message is returned.
    func validateFields() -> String? {
        
        // Check to see if all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // !!!!!!!!!! TODO !!!!!!!!!! Call email validation method here!
        
        // Check to see if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            
            // Password is not secure
            return "Your password must have least 8 characters and contain a number and special character"
        }
        
        return nil
    }
    
    // !!!!!!!!!! TODO !!!!!!!!!! We should figure out how to validate lakeside emails
    
    // Checks to see if the password is valid
    func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            
            // there is an error
            showError(error!)
        } else {
            
            // Create cleaned data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // Check for errors
                if error != nil {
                    
                    // There is an error in creating the user
                    self.showError("This email address has either been taken or is not valid")
                } else {
                    
                    // User creation was successful. Store first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Error occured
                            // !!!!!!!!!! TODO !!!!!!!!!!
                            self.showError("DATABASE STORING ERROR")
                        }
                    }
                    
                    // Go to home screen
                    self.goToNextscreen()
                }
            }
            
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goToFreePeriodEntries() {
        
    }
    
    func goToNextscreen() {
        
        let freePeriodSignupViewController =
            storyboard?.instantiateViewController(identifier:
            Constants.Storyboard.freePeriodSignupViewController) as?
            Free_Period_Signup_ViewController
        
        view.window?.rootViewController = freePeriodSignupViewController
        view.window?.makeKeyAndVisible()
        
        
    }
        
}
