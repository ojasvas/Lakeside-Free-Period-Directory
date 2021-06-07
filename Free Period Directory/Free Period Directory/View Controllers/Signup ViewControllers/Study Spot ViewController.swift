//
//  Study Spot ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 4/17/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Study_Spot_ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var selectedSpot: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        goBack()
    }
    private var data = [String]()
    
    var filteredData: [String]!
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        filteredData = []

        // Do any additional setup after loading the view.
    }
    
    //Gets the data from the entire study-spots database and appends it to the data array
    func getData(){
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
                    self?.data.append("\(name)")
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""{
            filteredData = []
        }
        
        else{
            for i in data {
                if i.lowercased().contains(searchText.lowercased()){
                    filteredData.append(i)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if selectedSpot.text == "" {
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
            ref.updateData(["favoriteStudySpot": self.selectedSpot.text!])
        self.goToNextScreen()
        }
        
    }
    
    func goBack(){
        let courseSignupViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.courseSignupViewController) as? Course_Signup_ViewController
        view.window?.rootViewController = courseSignupViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToNextScreen(){
        let interestSignupViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.interestSignupViewController) as? Interest_Signup_ViewController
        view.window?.rootViewController = interestSignupViewController
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

//Changes the selected spot to the name of the cell that was clicked on in the search tableview
extension Study_Spot_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
        selectedSpot.text = cell.name.text!
    }
}

extension Study_Spot_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return filteredData.count
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "studySpotCell")! as! Cell
        cell.name?.text = filteredData[indexPath.row]
        return cell
    }
    
}

