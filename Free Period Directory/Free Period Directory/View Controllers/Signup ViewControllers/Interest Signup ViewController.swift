//
//  Interest Signup ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 4/24/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Interest_Signup_ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet var selectedTableView: UITableView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var addInterestButton: UIButton!
    
    @IBOutlet weak var otherInterestTextField: UITextField!
    
    //Array for the data that will be displayed on the screeen
    private var data = [String]()
    
    var filteredData: [String]!
    
    var interestsSelected = [String]()
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchTableView.delegate = self
        selectedTableView.delegate = self
        searchTableView.dataSource = self
        selectedTableView.dataSource = self
        selectedTableView.isEditing = !selectedTableView.isEditing
        selectedTableView.separatorStyle = .none
        
        filteredData = data
        
        interestsSelected = []

        // Do any additional setup after loading the view.
    }
    
    //Gets the data from the entire cstudent-interests database and appends it to the data array
    func getData() {
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
                        self?.data.append("\(name)")
                    }
                }
                self?.searchTableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            filteredData = data
        }
        
        else{
            for i in data {
                if i.lowercased().contains(searchText.lowercased()){
                    filteredData.append(i)
                }
            }
        }
        self.searchTableView.reloadData()
    }
    
    
    
    @IBAction func submitPressed(_ sender: Any) {
        if interestsSelected.count < 1 {
            // Send alert if the user does not select at least 1 interest
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Choose an Interest", message: "Please select at least 1 interest", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            
           // call the user uid to set the value of his/her/their interest(s)
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)
           
           var i = 0
            
            while i < interestsSelected.count {
                let interestNum = i + 1
                let interestName = "interest\(String(interestNum))"
                ref.updateData([
                   interestName: interestsSelected[i]
                ])
                i = i + 1
            }
            self.goToHomeScreen()
        }
        
    }
    
    @IBAction func addInterestPressed(_ sender: Any) {
        var wasRepeat = false
        if otherInterestTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let errorAlert = UIAlertController(title: "Type an Interest", message: "Please type an interest into box before adding interest", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else {
            for i in self.data {
                if i.lowercased().contains(self.otherInterestTextField.text!.lowercased()){
                    let errorAlert = UIAlertController(title: "Repeat Interest", message: "The interest you submitted is already in our database", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The error alert occured.")
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    wasRepeat = true
                }
            }
            if wasRepeat == false{
                let db = Firestore.firestore()
                let ref = db.collection("student-interests")
                ref.addDocument(data: ["interest-name": otherInterestTextField.text!, "notApproved": true])
            }
        }
        otherInterestTextField.text = ""
    }
    
    func goToHomeScreen(){
        let homeViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? Home_ViewController
        view.window?.rootViewController = homeViewController
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

extension Interest_Signup_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
        if tableView == searchTableView{
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
            
            var interestRepeat = false
            
            for i in interestsSelected {
                if i == cell.name.text{
                    interestRepeat = true
                }
            }
            
            if interestRepeat == false{
                interestsSelected.append(cell.name.text ?? "")
                selectedTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == selectedTableView{
            if editingStyle == .delete{
                interestsSelected.remove(at: indexPath.item)
                selectedTableView.reloadData()
            }
        }
    }
}

extension Interest_Signup_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        switch tableView {
        case searchTableView:
            return filteredData.count
        case selectedTableView:
            return interestsSelected.count
        default:
            print("Error")
            return 1
        }
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch tableView {
        case searchTableView:
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "interestCell")! as! Cell
            cell.name?.text = filteredData[indexPath.row]
            return cell
        case selectedTableView:
            let cell = selectedTableView.dequeueReusableCell(withIdentifier: "selectedInterestCell")! as! Cell
            cell.name?.text = interestsSelected[indexPath.row]
            cell.backgroundColor = UIColor.gray
            return cell
        default:
            print("Error")
            let cell = UITableViewCell()
            return cell
        }
    }
}


