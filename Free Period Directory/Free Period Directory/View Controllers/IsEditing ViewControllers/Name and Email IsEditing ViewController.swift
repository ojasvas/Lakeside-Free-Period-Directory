//
//  Name and Email IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Name_and_Email_IsEditing_ViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        errorLabel.alpha = 0
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
                    self.firstNameTextField.text = (document.get("firstname") as! String)
                }
                else{
                    self.firstNameTextField.text = "N/A"
                }
                if document.get("lastname") != nil{
                    self.lastNameTextField.text = (document.get("lastname") as! String)
                }
                else{
                    self.lastNameTextField.text = "N/A"
                }
                if user.email != nil{
                    self.emailTextField.text = user.email
                }
                else{
                    self.emailTextField.text = "N/A"
                }
            }
        }
    }
    
    // Check the field and validate that the data is correct.
    // If everything is correct, nil is returned. Otherwise and error message is returned.
    func validateFields() -> String? {
        
        // Check to see if all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
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
        var emailIdIndex = 0
        for (index, char) in email.enumerated() {
            if char == "@" {
                emailIdIndex = index
                break
            }
        }
        let emailIdSection = email[email.startIndex..<email.index(email.startIndex, offsetBy: emailIdIndex)]
        var emailIdTest = first.lowercased() + last[last.startIndex...last.startIndex].lowercased()
        
        var testNumStart = 0
        var testNumEnd = 0
        for (index, char) in email.enumerated() {
            if char.isNumber && testNumStart == 0 {
                testNumStart = index
            } else if char.isNumber && testNumStart != 0 && testNumEnd == 0 {
                testNumEnd = index
                break
            }
        }
        var gradYrsTest = Int()
        if testNumEnd == 0 {
            return false
        } else if testNumEnd - testNumStart != 1 {
            return false
        } else {
            let numStart = Int(email[email.index(email.startIndex, offsetBy: testNumStart)...email.index(email.startIndex, offsetBy: testNumStart)]) ?? 0
            let numEnd = Int(email[email.index(email.startIndex, offsetBy: testNumEnd)...email.index(email.startIndex, offsetBy: testNumEnd)]) ?? 0
            gradYrsTest = numStart * 10 + numEnd
        }
        // https://coderwall.com/p/b8pz5q/swift-4-current-year-mont-day
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        let twoDigitYrIndex = formattedDate.index(formattedDate.startIndex, offsetBy: 2)
        let twoDigitYr = Int(formattedDate[twoDigitYrIndex...formattedDate.index(after: twoDigitYrIndex)]) ?? 0
        if (gradYrsTest < twoDigitYr) || (gradYrsTest > twoDigitYr + 3) {
            return false
        }
        
        emailIdTest += String(gradYrsTest)
        if emailIdTest != emailIdSection {
            return false
        }
        
        let emailDomainTest = "@lakesideschool.org"
        let emailDomainSection = email[email.index(email.startIndex, offsetBy: emailIdIndex)..<email.endIndex]
        if emailDomainTest != emailDomainSection {
            return false
        }

        return true
    }
    
    @IBAction func doneEditingButtonTapped(_ sender: Any) {
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            
            // there is an error
            showError(error!)
        } else {
            
            // Create cleaned data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            print(firstName)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let user = Auth.auth().currentUser
            user?.updateEmail(to: email)
            let userUID = user!.uid
            let db = Firestore.firestore()
            let ref = db.collection("users").document(userUID)
            ref.updateData(["firstname": firstName])
            ref.updateData(["lastname": lastName])
        }
        
        goToUserProfileScreen()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goToUserProfileScreen() {
        let userProfileViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.userProfileViewController) as? UserProfileViewController
        view.window?.rootViewController = userProfileViewController
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
