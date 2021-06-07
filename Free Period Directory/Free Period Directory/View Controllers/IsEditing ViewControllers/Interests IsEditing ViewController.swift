//
//  Interests IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Interests_IsEditing_ViewController: UIViewController{
    
    @IBOutlet weak var interest1TextField: UITextField!
    
    @IBOutlet weak var interest2TextField: UITextField!
    
    @IBOutlet weak var interest3TextField: UITextField!
    
    @IBOutlet weak var interestsSearchTableView1: UITableView!
    
    @IBOutlet weak var interestsSearchTableView2: UITableView!
    
    @IBOutlet weak var interestsSearchTableView3: UITableView!
    
    var interestsSearch1 = ""
    
    var interestsSearch2 = ""
    
    var interestsSearch3 = ""
    
    private var interestsData = [String]()
    
    private var interestsSearchData1 = [String]()
    
    private var interestsSearchData2 = [String]()
    
    private var interestsSearchData3 = [String]()
    
    var interestsTextFieldsArray = [UITextField]()
    
    var interestsSelected = [String]()
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
    }
    
    override func viewDidLoad() {
        getUserData()
        getTableData()
        interestsSearchData1 = interestsData
        interestsSearchData2 = interestsData
        interestsSearchData3 = interestsData
        interestsSearchTableView1.alpha = 0
        interestsSearchTableView1.delegate = self
        interestsSearchTableView1.dataSource = self
        interestsSearchTableView2.alpha = 0
        interestsSearchTableView2.delegate = self
        interestsSearchTableView2.dataSource = self
        interestsSearchTableView3.alpha = 0
        interestsSearchTableView3.delegate = self
        interestsSearchTableView3.dataSource = self
        interest1TextField.delegate = self
        interest2TextField.delegate = self
        interest3TextField.delegate = self
        interestsTextFieldsArray = [interest1TextField, interest2TextField, interest3TextField]
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
                var k = 1
                while k < 4{
                    if document.get("interest"+String(k)) != nil{
                        self.interestsTextFieldsArray[k-1].text = (document.get("interest"+String(k)) as! String)
                    }
                    else{
                        self.interestsTextFieldsArray[k-1].text = "N/A"
                    }
                    k+=1
                }
            }
        }
    }
    
    func getTableData(){
        let db = Firestore.firestore()
        db.collection("student-interests").getDocuments{[weak self] snap, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else{
                guard let snapshot = snap else {return}
                for document in snapshot.documents{
                    let i = document.data()
                    var notApproved = false
                    // https://stackoverflow.com/questions/52980666/how-to-check-if-a-document-contains-a-property-in-cloud-firestore
                    if i["notApproved"] != nil {
                        notApproved = i["notApproved"] as! Bool
                    }
                    if notApproved != true{
                        let name = i["interest-name"] as! String
                        self?.interestsData.append("\(name)")
                    }
                }
                self?.interestsSearchTableView1.reloadData()
                self?.interestsSearchTableView2.reloadData()
                self?.interestsSearchTableView3.reloadData()
            }
        }
    }
    
    // Saves changes to the database
    @IBAction func doneEditingTapped(_ sender: Any) {
        interestsSelected = [interest1TextField.text!, interest2TextField.text!, interest3TextField.text!]
        var interestCount =  0
        var i = 0
        //checks if the text in the text field is blank
        while i < 3{
            if interestsSelected[i] != nil && interestsSelected[i] != "" && interestsSelected[i] != "N/A"{
                interestCount += 1
            }
            else{
                interestsSelected[i] = "N/A"
            }
            i += 1
        }
        var isInterest = 0
        
        //checks if the text  in the text field is in the interests database
        for i in interestsSelected {
            if i == "" || i == "N/A"{
                isInterest = isInterest + 1
            }
            else{
                for j in interestsData{
                    if i == j{
                        isInterest = isInterest + 1
                    }
                }
            }
        }
        if interestCount < 1 {
            // Send alert if the user does not select at least 1 interest
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select at least 1 interest", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else if interestsSelected.count > 3{
                    // Send alert if the user has more than 3 interests
                    // Source: developer.apple.com
                    let errorAlert = UIAlertController(title: "Error!", message: "Please select no more than 3 interests", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The error alert occured.")
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
        }
        else if isInterest < 3 {
            // Send alert if the user picks an interest that isn't in the database
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "One or more of your interests are not in the interest bank. Please only select interests in the interest bank.", preferredStyle: .alert)
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
                let interestNum = i + 1
                let interestName = "interest\(String(interestNum))"
                ref.updateData([
                   interestName: interestsSelected[i]
                ])
                i = i + 1
            }
            
            self.goToUserProfileScreen()
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
// https://stackoverflow.com/questions/26446376/how-to-make-uitextfield-behave-like-a-uisearchbar-in-swift
extension Interests_IsEditing_ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == interest1TextField{
            if string.isEmpty {
                interestsSearch1 = String(textField.text!.dropLast())
                interestsSearchData1 = interestsData
            }
            else
            {
                interestsSearch1=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in interestsData {
                if i.lowercased().contains(interestsSearch1.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                interestsSearchData1.removeAll(keepingCapacity: true)
                interestsSearchData1 = filteredArray
            }
            else
            {
                interestsSearchData1=interestsData
            }
            self.interestsSearchTableView1.reloadData()
        }
        else if textField == interest2TextField{
            if string.isEmpty {
                interestsSearch2 = String(textField.text!.dropLast())
                interestsSearchData2 = interestsData
            }
            else
            {
                interestsSearch2=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in interestsData {
                if i.lowercased().contains(interestsSearch2.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                interestsSearchData2.removeAll(keepingCapacity: true)
                interestsSearchData2 = filteredArray
            }
            else
            {
                interestsSearchData2=interestsData
            }
            self.interestsSearchTableView2.reloadData()
        }
        else if textField == interest3TextField{
            if string.isEmpty {
                interestsSearch3 = String(textField.text!.dropLast())
                interestsSearchData3 = interestsData
            }
            else
            {
                interestsSearch3=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in interestsData {
                if i.lowercased().contains(interestsSearch3.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                interestsSearchData3.removeAll(keepingCapacity: true)
                interestsSearchData3 = filteredArray
            }
            else
            {
                interestsSearchData3=interestsData
            }
            self.interestsSearchTableView3.reloadData()
        }
        return true
    }
    
    //https://stackoverflow.com/questions/45908469/how-do-you-show-table-view-only-when-search-bar-is-clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == interest1TextField {
            interestsSearchTableView1.alpha = 1
        }
        else if textField == interest2TextField{
            interestsSearchTableView2.alpha = 1
        }
        else if textField == interest3TextField{
            interestsSearchTableView3.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == interest1TextField {
            interestsSearchTableView1.alpha = 0
        }
        else if textField == interest2TextField{
            interestsSearchTableView2.alpha = 0
        }
        else if textField == interest3TextField{
            interestsSearchTableView3.alpha = 0
        }
    }
}

extension Interests_IsEditing_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if tableView == interestsSearchTableView1{
            return interestsSearchData1.count
        }
        else if tableView == interestsSearchTableView2{
            return interestsSearchData2.count
        }
        else if tableView == interestsSearchTableView3{
            return interestsSearchData3.count
        }
        else{
            print("Error")
            return 1
        }
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == interestsSearchTableView1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell")!  as! Cell
            cell.name.text = interestsSearchData1[indexPath.row]
            return cell
        }
        else if tableView == interestsSearchTableView2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell")!  as! Cell
            cell.name.text = interestsSearchData2[indexPath.row]
            return cell
        }
        else if tableView == interestsSearchTableView3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell")!  as! Cell
            cell.name.text = interestsSearchData3[indexPath.row]
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
}

// Fills the text field with the name of the cell the user clicked on if it has not already been selected as another interest
extension Interests_IsEditing_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
        interestsSelected = [interest1TextField.text!, interest2TextField.text!, interest3TextField.text!]
        
        var interestRepeat = false
        
        for i in interestsSelected {
            if i == cell.name.text{
                interestRepeat = true
            }
        }
        
        if interestRepeat == false{
            if tableView == interestsSearchTableView1{
                interest1TextField.text = cell.name.text
            }
            else if tableView == interestsSearchTableView2{
                interest2TextField.text = cell.name.text
            }
            else if tableView == interestsSearchTableView3{
                interest3TextField.text = cell.name.text
            }
        }
    }
}
