//
//  Signup ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/21/21.
//

import UIKit
import Firebase
import FirebaseAuth

// https://stackoverflow.com/questions/58952151/strong-password-overlay-on-uitextfield
// fixed strong password overlay bug
extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

class Signup_ViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
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
        
        passwordTextField.disableAutoFill()
        
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
        
        // Check to see if the email is believable and for Lakeside
        let cleanedFirst = firstNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let cleanedLast = lastNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
        if !isEmailValid(cleanedEmail) {
            return "Please enter a real email with appropriate characters"
        }
        if !isEmailLakeside(cleanedFirst, cleanedLast, cleanedEmail) {
            return "Please enter your Lakeside email"
        }
        
        // Check to see if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            
            // Password is not secure
            return "Your password must have least 8 characters and contain a number and special character"
        }
        
        return nil
    }
    
    // Uses regex to allow expected characters and check overall email format
    // https://stackoverflow.com/a/41782027
    func isEmailValid(_ email: String) -> Bool {
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        return __emailPredicate.evaluate(with: email)
    }
    
    // Checks that email follows Lakeside format
    // Compares test substrings to appropriate sections of user inputted email
    func isEmailLakeside(_ first: String, _ last: String, _ email: String) -> Bool {
        var emailNamesTest = String()
        emailNamesTest += first.lowercased() + last[last.startIndex...last.startIndex].lowercased()
        
        let numStart = email.index(email.startIndex, offsetBy: emailNamesTest.count)
        let numEnd = email.index(after: numStart)
        var emailGradYrsTest = String()
        emailGradYrsTest += email[numStart...numEnd]
        
        let emailDomainTest = "@lakesideschool.org"
        
        let emailNames = email[email.startIndex..<numStart]
        if emailNames != emailNamesTest {
            return false
        }
        
        // Just checking for two numbers
//        for char in emailGradYrsTest {
//            if !char.isNumber {
//                return false
//            }
//        }
        
        let domainStart = email.index(after: numEnd)
        let domainEnd = email.index(email.endIndex, offsetBy: -1)
        var emailDomain = String()
        emailDomain += email[domainStart...domainEnd]
        if emailDomain != emailDomainTest {
            return false
        }
        
        return true
    }
    
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
                    
                    db.collection("users").document(result!.user.uid).setData( ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid, "free1":"", "free2":""]) { (error) in
                        
                        if error != nil {
                            // Error occured
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
    
    func goBack(){
        let initialViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.initialViewController) as? ViewController
        
        view.window?.rootViewController = initialViewController
        view.window?.makeKeyAndVisible()
    }
        
}
