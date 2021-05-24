//
//  Course Signup ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 3/31/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Course_Signup_ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet var selectedTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    //Array for the data that will be displayed on the screeen—just course code and name
    private var data = [String]()
    
    //Array containing all courses as objects of type dataType (not currently in use, but useful for further sorting of courses)
    private var courses = [dataType]()
    
    var filteredData: [String]!
    
    var coursesSelected = [String]()
    
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
        
        filteredData = []
        
        coursesSelected = []

        // Do any additional setup after loading the view.
    }
    
    //Gets the data from the entire courses database and appends it to the courses and data arrays
    func getData(){
        let db = Firestore.firestore()
        db.collection("courses").getDocuments{[weak self] snap, err in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else{
                guard let snapshot = snap else {return}
                for document in snapshot.documents{
                    let i = document.data()
                    let id = document.documentID
                    let code = i["course-code"] as! String
                    let name = i["course-name"] as! String
                    let offering = i["currently-offering"] as! Bool
                    let department = i["department-name"] as! String
                    self?.courses.append(dataType(id: id, code: code, name: name, offering: offering, department: department))
                    self?.data.append("\(code) \(name)")
                }
                self?.searchTableView.reloadData()
            }
        }
    }
    
    //Creating a struct for a course data type
    struct dataType: Identifiable{
        var id: String
        var code: String
        var name: String
        var offering: Bool
        var department: String
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
        self.searchTableView.reloadData()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if coursesSelected.count < 4 {
            // Send alert if the user does not select at least 5 courses
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select at least 5 courses", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else if coursesSelected.count > 7 {
                    // Send alert if the user has more than 7 courses
                    // Source: developer.apple.com
                    let errorAlert = UIAlertController(title: "Error!", message: "Please select no more than 7 courses", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The error alert occured.")
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
        }
        
        else {
            
           // call the user uid to set the value of his/her/their courses
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)
           
           var i = 0
            
            while i < coursesSelected.count {
                let courseNum = i + 1
                let courseName = "course\(String(courseNum))"
                ref.updateData([
                   courseName: coursesSelected[i]
                ])
                i = i + 1
            }
            
            if coursesSelected.count == 5 {
                ref.updateData([
                    "course6": "N/A",
                    "course7": "N/A"
                ])
            }
            
            if coursesSelected.count == 6 {
                ref.updateData([
                    "course7": "N/A"
                ])
            }
            
            self.goToNextScreen()
        }
        
    }
    
    func goToNextScreen(){
        let studySpotViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.studySpotViewController) as? Study_Spot_ViewController
        view.window?.rootViewController = studySpotViewController
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

extension Course_Signup_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
        if tableView == searchTableView{
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
            
            var courseRepeat = false
            
            for i in coursesSelected {
                if i == cell.name.text{
                    courseRepeat = true
                }
            }
            
            if courseRepeat == false{
                coursesSelected.append(cell.name.text ?? "")
                selectedTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == selectedTableView{
            if editingStyle == .delete{
                coursesSelected.remove(at: indexPath.item)
                selectedTableView.reloadData()
            }
        }
    }
}

extension Course_Signup_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        switch tableView {
        case searchTableView:
            return filteredData.count
        case selectedTableView:
            return coursesSelected.count
        default:
            print("Error")
            return 1
        }
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch tableView {
        case searchTableView:
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "courseCell")! as! Cell
            cell.name?.text = filteredData[indexPath.row]
            return cell
        case selectedTableView:
            let cell = selectedTableView.dequeueReusableCell(withIdentifier: "selectedCourseCell")! as! Cell
            cell.name?.text = coursesSelected[indexPath.row]
            cell.backgroundColor = UIColor.gray
            return cell
        default:
            print("Error")
            let cell = UITableViewCell()
            return cell
        }
    }
    
}
