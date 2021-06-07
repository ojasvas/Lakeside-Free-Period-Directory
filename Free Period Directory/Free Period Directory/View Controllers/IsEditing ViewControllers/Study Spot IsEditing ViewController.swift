//
//  Study Spot IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Study_Spot_IsEditing_ViewController: UIViewController{
    
    @IBOutlet weak var favoriteStudySpotTextField: UITextField!
    
    @IBOutlet weak var studySpotSearchTableView: UITableView!
    
    var studySpotSearch = ""
    
    private var studySpotData = [String]()
    
    private var studySpotSearchData = [String]()
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
    }
    
    @IBAction func doneEditingTapped(_ sender: Any) {
        if favoriteStudySpotTextField.text == "" {
            // Send alert if the user does not select a favorite study spot
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select your favorite or indicate no preference", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            
           // call the user uid to set the value of his/her/their favorite study spot
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)
           ref.updateData(["favoriteStudySpot": self.favoriteStudySpotTextField.text!])
        self.goToUserProfileScreen()
        }
    }
    
    override func viewDidLoad() {
        getUserData()
        getTableData()
        studySpotSearchData = studySpotData
        studySpotSearchTableView.alpha = 0
        studySpotSearchTableView.delegate = self
        studySpotSearchTableView.dataSource = self
        favoriteStudySpotTextField.delegate = self
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
                if document.get("favoriteStudySpot") != nil{
                    self.favoriteStudySpotTextField.text = (document.get("favoriteStudySpot") as! String)
                }
                else{
                    self.favoriteStudySpotTextField.text = "N/A"
                }
            }
        }
    }
    
    func getTableData(){
        let db = Firestore.firestore()
        db.collection("study-spots").getDocuments{[weak self] snap, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else{
                guard let snapshot = snap else {return}
                for document in snapshot.documents{
                    let i = document.data()
                    let name = i["spot-name"] as! String
                    self?.studySpotData.append("\(name)")
                }
                self?.studySpotSearchTableView.reloadData()
            }
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
extension Study_Spot_IsEditing_ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            studySpotSearch = String(textField.text!.dropLast())
            studySpotSearchData = studySpotData
        }
        else
        {
            studySpotSearch=textField.text!+string
        }
        
        var filteredArray:[String] = []
        for i in studySpotData {
            if i.lowercased().contains(studySpotSearch.lowercased()){
                filteredArray.append(i)
            }
        }
        if filteredArray.count > 0
        {
            studySpotSearchData.removeAll(keepingCapacity: true)
            studySpotSearchData = filteredArray
        }
        else
        {
            studySpotSearchData=studySpotData
        }
        self.studySpotSearchTableView.reloadData()
        return true
    }
    
    //https://stackoverflow.com/questions/45908469/how-do-you-show-table-view-only-when-search-bar-is-clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
        studySpotSearchTableView.alpha = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        studySpotSearchTableView.alpha = 0
    }
}

extension Study_Spot_IsEditing_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return studySpotSearchData.count
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySpotCell")!  as! Cell
        cell.name.text = studySpotSearchData[indexPath.row]
        return cell
    }
    
}

extension Study_Spot_IsEditing_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
        favoriteStudySpotTextField.text = cell.name.text
    }
}

//
//  UserProfileIsEditingViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/17/21.
//
