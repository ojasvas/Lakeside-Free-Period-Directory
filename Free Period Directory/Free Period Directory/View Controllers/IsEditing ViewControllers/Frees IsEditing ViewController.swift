//
//  Frees Is Editing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Frees_IsEditing_ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var free1TextField: UITextField!
    
    @IBOutlet weak var free2TextField: UITextField!
    
    @IBOutlet weak var free3TextField: UITextField!
    
    @IBOutlet weak var free1Picker: UIPickerView!
    
    @IBOutlet weak var free2Picker: UIPickerView!
    
    @IBOutlet weak var free3Picker: UIPickerView!
    
    var freesTextFieldArray = [UITextField]()
    
    var freesSelected = [String]()
    
    var freesPickerData = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "N/A"]
    
    override func viewDidLoad() {
        getUserData()
        super.viewDidLoad()
        self.free1Picker.delegate = self
        self.free1Picker.dataSource = self
        self.free2Picker.delegate = self
        self.free2Picker.dataSource = self
        self.free3Picker.delegate = self
        self.free3Picker.dataSource = self
        self.free1Picker.alpha = 0
        self.free2Picker.alpha = 0
        self.free3Picker.alpha = 0
        free1TextField.delegate = self
        free2TextField.delegate = self
        free3TextField.delegate = self
        freesTextFieldArray = [free1TextField, free2TextField, free3TextField]
        // Do any additional setup after loading the view.
    }
    
    func getUserData(){
        guard let user = Auth.auth().currentUser else {return}
        let userUID = user.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                var i = 1
                while i < 4{
                    if document.get("free"+String(i)) != nil{
                        self.freesTextFieldArray[i-1].text = (document.get("free"+String(i)) as! String)
                    }
                    else{
                        self.freesTextFieldArray[i-1].text = "N/A"
                    }
                    i+=1
                }
            }
        }
    }
    
    @IBAction func doneEditingButtonTapped(_ sender: Any) {
        freesSelected = [free1TextField.text!, free2TextField.text!, free3TextField.text!]
        var freeCount =  0
        var i = 0
        while i < 3{
            if freesSelected[i] != nil && freesSelected[i] != "" && freesSelected[i] != "N/A"{
                freeCount += 1
            }
            else{
                freesSelected[i] = "N/A"
            }
            i += 1
        }
        var isFree = 0
        
        for i in freesSelected {
            if i == ""{
                isFree = isFree + 1
            }
            else{
                for j in freesPickerData{
                    if i == j{
                        isFree = isFree + 1
                    }
                }
            }
        }
        
        var freeRepeat = false
        
        if freesSelected[0] != "N/A" || freesSelected[0] != ""{
            if freesSelected[0] == freesSelected[1] || freesSelected[0] == freesSelected[2]{
                freeRepeat = true
            }
        }
        
        if freesSelected[1] != "N/A" || freesSelected[1] != ""{
            if freesSelected[1] == freesSelected[2]{
                freeRepeat = true
            }
        }
        
        if freeCount < 1 {
            // Send alert if the user does not select at least 1 free
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select at least 1 free", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else if freesSelected.count > 3{
                    // Send alert if the user has more than 3 frees
                    // Source: developer.apple.com
                    let errorAlert = UIAlertController(title: "Error!", message: "Please select no more than 3 frees", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The error alert occured.")
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
        }
        else if isFree < 3 {
            // Send alert if the user picks a free that isn't in the database
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "One or more of your frees are not in the free bank. Please only select one of the listed options for frees.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else if freeRepeat == true{
            // Send alert if the user picks a free more than once
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "One or more of your frees are the same. Please only select unique frees or choose N/A", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else {
            
           // call the user uid to set the value of his/her/their interest(s)
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)
           
           var i = 0
            
            while i < 3 {
                let freeNum = i + 1
                let freeName = "free\(String(freeNum))"
                ref.updateData([
                   freeName: freesSelected[i]
                ])
                i = i + 1
            }
            
            self.goToUserProfileScreen()
        }
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return freesPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return freesPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == free1Picker{
            free1TextField.text = freesPickerData[row]
        }
        else if pickerView == free2Picker{
            free2TextField.text = freesPickerData[row]
        }
        else if pickerView == free3Picker{
            free3TextField.text = freesPickerData[row]
        }
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

extension Frees_IsEditing_ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == free1TextField {
            free1Picker.alpha = 1
        }
        else if textField == free2TextField{
            free2Picker.alpha = 1
        }
        else if textField == free3TextField{
            free3Picker.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == free1TextField {
            free1Picker.alpha = 0
        }
        else if textField == free2TextField{
            free2Picker.alpha = 0
        }
        else if textField == free3TextField{
            free3Picker.alpha = 0
        }
    }
}
