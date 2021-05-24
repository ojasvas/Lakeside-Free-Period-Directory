//
//  Free Period Signup ViewController.swift
//  Free Period Directory
//
//  Created by Student on 3/7/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Free_Period_Signup_ViewController: UIViewController {

    @IBOutlet weak var titleMessage: UILabel!

    @IBOutlet weak var firstPeriod: UILabel!

    @IBOutlet weak var secondPeriod: UILabel!

    @IBOutlet weak var thirdPeriod: UILabel!

    @IBOutlet weak var fourthPeriod: UILabel!

    @IBOutlet weak var fifthPeriod: UILabel!

    @IBOutlet weak var sixthPeriod: UILabel!

    @IBOutlet weak var seventhPeriod: UILabel!

    @IBOutlet weak var eighthPeriod: UILabel!

    @IBOutlet weak var firstFreeSwitch: UISwitch!

    @IBOutlet weak var secondFreeSwitch: UISwitch!

    @IBOutlet weak var thirdFreeSwitch: UISwitch!

    @IBOutlet weak var fourthFreeSwitch: UISwitch!

    @IBOutlet weak var fifthFreeSwitch: UISwitch!

    @IBOutlet weak var sixthFreeSwitch: UISwitch!

    @IBOutlet weak var seventhFreeSwitch: UISwitch!

    @IBOutlet weak var eighthFreeSwitch: UISwitch!

    @IBOutlet weak var noSecondFree: UISwitch!

    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserHasFrees()
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

    func checkIfUserHasFrees(){
        guard let user = Auth.auth().currentUser else { return }
        let userUID = user.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                var free1 = "none"
                var free2 = "none"
                var free3 = "none"
                if document.get("free1") != nil{
                    free1 = document.get("free1") as! String
                }
                if document.get("free2") != nil{
                    free2 = document.get("free2") as! String
                }
                if document.get("free3") != nil{
                    free3 = document.get("free3") as! String
                }
                if free1 == "first" || free2 == "first" || free3 == "first"{
                    self.firstFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "second" || free2 == "second" || free3 == "second"{
                    self.secondFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "third" || free2 == "third" || free3 == "third"{
                    self.thirdFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "fourth" || free2 == "fourth" || free3 == "fourth" {
                    self.fourthFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "fifth" || free2 == "fifth" || free3 == "fifth"{
                    self.fifthFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "sixth" || free2 == "sixth" || free3 == "sixth"{
                    self.sixthFreeSwitch.setOn(true, animated: false)
                }
                if free1 == "seventh" || free2 == "seventh" || free3 == "seventh"{
                    self.seventhFreeSwitch.setOn(true, animated: false)
                }
            }
        }
    }

    // check if at least one switch is on
    func validateSwitches() -> Bool {
        if firstFreeSwitch.isOn ||
            secondFreeSwitch.isOn ||
            thirdFreeSwitch.isOn ||
            fourthFreeSwitch.isOn ||
            fifthFreeSwitch.isOn ||
            sixthFreeSwitch.isOn ||
            seventhFreeSwitch.isOn ||
            eighthFreeSwitch.isOn {

            return true
        }
        return false
    }

    func whatFrees() -> [String] {
        var frees: [String] = []
        if firstFreeSwitch.isOn {
            frees.append("first")
        }
        if secondFreeSwitch.isOn {
            frees.append("second")
        }
        if thirdFreeSwitch.isOn {
            frees.append("third")
        }
        if fourthFreeSwitch.isOn {
            frees.append("fourth")
        }
        if fifthFreeSwitch.isOn {
            frees.append("fifth")
        }
        if sixthFreeSwitch.isOn {
            frees.append("sixth")
        }
        if seventhFreeSwitch.isOn {
            frees.append("seventh")
        }
        if eighthFreeSwitch.isOn {
            frees.append("eighth")
        }
        if noSecondFree.isOn {
            frees.append("N/A")
        }
        return frees
    }

    @IBAction func nextPressed(_ sender: Any) {

        // check validity
<<<<<<< HEAD
        var isValid = validateSwitches()
        let frees = whatFrees()
        let numFrees = frees.count
        if numFrees > 3{
            isValid = false
        }
        if isValid == false {
            // Send alert if the user does select any frees
=======
        let frees = self.whatFrees()
        if frees.count != 2 {
            // Send alert if the user does not select two options
>>>>>>> 0ef89ef5198c8ab37d18b45a6b158fb7e7b4a648
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select two options", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
<<<<<<< HEAD
            var i = 0
=======
           let numFrees = frees.count
           var i = 0
>>>>>>> 0ef89ef5198c8ab37d18b45a6b158fb7e7b4a648

           // call the user uid to set the value of his/her/their frees
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)

           while i < numFrees {

               let freeNumber = i + 1
               let freeName = "free\(String(freeNumber))"
               ref.updateData([
                  freeName: frees[i]
               ])
               i = i + 1
            }
            self.goToNextScreen()
        }
   }
   func goToNextScreen(){
      let courseSignupViewController =
          storyboard?.instantiateViewController(identifier: Constants.Storyboard.courseSignupViewController) as? Course_Signup_ViewController
      view.window?.rootViewController = courseSignupViewController
      view.window?.makeKeyAndVisible()
    }


    func goToHomescreen() {

        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? Home_ViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
