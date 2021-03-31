//
//  Login ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/21/21.
//

import UIKit
import FirebaseAuth

class Login_ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        goBack()
    }
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
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // !!!!!!!!!! TODO !!!!!!!!!! Call email validation method here!
        
        // Check to see if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            
            // Password is not secure
            return "Please make sure your password is at least 8 characters, contains a special character, and a number"
        }
        
        return nil
    }
    
    // !!!!!!!!!! TODO !!!!!!!!!! We should figure out how to validate lakeside emails
    
    // Checks to see if the password is valid
    func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func loginTapped(_ sender: Any) {

        // Create cleaned versions of text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Logging in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                
                // Could not sign in
                self.errorLabel.text = "Email or password was incorrect"
                self.errorLabel.alpha = 1
            } else {
                
                self.goToHomescreen()
            }
        }
    }
    
    func goBack(){
        let initialViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.initialViewController) as? ViewController
        
        view.window?.rootViewController = initialViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToHomescreen() {
        
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? Home_ViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
