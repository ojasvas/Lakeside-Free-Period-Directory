//
//  Courses IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Courses_IsEditing_ViewController: UIViewController{
    
    @IBOutlet weak var favoriteStudySpotTextField: UITextField!
    
    @IBOutlet weak var studySpotSearchTableView: UITableView!
    
    var studySpotSearch = ""
    
    private var studySpotData = [String]()
    
    private var studySpotSearchData = [String]()
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        goToHomeScreen()
    }
    
    @IBAction func doneEditingTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        getTableData()
        studySpotSearchData = studySpotData
        studySpotSearchTableView.alpha = 0
        studySpotSearchTableView.delegate = self
        studySpotSearchTableView.dataSource = self
        favoriteStudySpotTextField.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
// https://stackoverflow.com/questions/26446376/how-to-make-uitextfield-behave-like-a-uisearchbar-in-swift
extension Courses_IsEditing_ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            studySpotSearch = String(textField.text!.dropLast())
            studySpotSearchData = studySpotData
            print("empty")
        }
        else
        {
            studySpotSearch=textField.text!+string
            print("istext")
        }
        
        var filteredArray:[String] = []
        for i in studySpotData {
            if i.lowercased().contains(studySpotSearch.lowercased()){
                filteredArray.append(i)
                print("added")
            }
        }
        if filteredArray.count > 0
        {
            studySpotSearchData.removeAll(keepingCapacity: true)
            studySpotSearchData = filteredArray
            print("hasdata")
            print(filteredArray)
            print(studySpotSearchData)
        }
        else
        {
            studySpotSearchData=studySpotData
            print("no data")
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

extension Courses_IsEditing_ViewController: UITableViewDataSource{
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

extension Courses_IsEditing_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
        favoriteStudySpotTextField.text = cell.name.text
    }
}

//
//  Study Spot IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//
