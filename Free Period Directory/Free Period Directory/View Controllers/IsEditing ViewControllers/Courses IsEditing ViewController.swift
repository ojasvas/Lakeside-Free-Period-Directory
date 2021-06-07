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
    
    @IBOutlet weak var course1TableView: UITableView!
    
    @IBOutlet weak var course2TableView: UITableView!
    
    @IBOutlet weak var course3TableView: UITableView!
    
    @IBOutlet weak var course4TableView: UITableView!
    
    @IBOutlet weak var course5TableView: UITableView!
    
    @IBOutlet weak var course6TableView: UITableView!
    
    @IBOutlet weak var course7TableView: UITableView!
    
    @IBOutlet weak var course1TextField: UITextField!
    
    @IBOutlet weak var course2TextField: UITextField!
    
    @IBOutlet weak var course3TextField: UITextField!
    
    @IBOutlet weak var course4TextField: UITextField!
    
    @IBOutlet weak var course5TextField: UITextField!
    
    @IBOutlet weak var course6TextField: UITextField!
    
    @IBOutlet weak var course7TextField: UITextField!
    
    private var coursesData = [String]()
    
    var coursesSearch1 = ""
    
    var coursesSearch2 = ""
    
    var coursesSearch3 = ""
    
    var coursesSearch4 = ""
    
    var coursesSearch5 = ""
    
    var coursesSearch6 = ""
    
    var coursesSearch7 = ""
    
    private var coursesSearchData1 = [String]()
    
    private var coursesSearchData2 = [String]()
    
    private var coursesSearchData3 = [String]()
    
    private var coursesSearchData4 = [String]()
    
    private var coursesSearchData5 = [String]()
    
    private var coursesSearchData6 = [String]()
    
    private var coursesSearchData7 = [String]()
    
    var coursesTextFieldsArray = [UITextField]()
    
    var coursesSelected = [String]()
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        goToUserProfileScreen()
    }
    
    @IBAction func doneEditingTapped(_ sender: Any) {
        coursesSelected = [course1TextField.text!, course2TextField.text!, course3TextField.text!, course4TextField.text!, course5TextField.text!, course6TextField.text!, course7TextField.text!]
        var courseCount =  0
        var i = 0
        while i < 7{
            if coursesSelected[i] != nil && coursesSelected[i] != "" && coursesSelected[i] != "N/A"{
                courseCount += 1
            }
            else{
                coursesSelected[i] = "N/A"
            }
            i += 1
        }
        var iscourse = 0
        
        for i in coursesSelected {
            if i == "" || i == "N/A"{
                iscourse = iscourse + 1
            }
            else{
                for j in coursesData{
                    if i == j{
                        iscourse = iscourse + 1
                    }
                }
            }
        }
        
        if courseCount < 4 {
            // Send alert if the user does not select at least 1 course
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "Please select at least 4 courses", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else if coursesSelected.count > 7{
                    // Send alert if the user has more than 3 courses
                    // Source: developer.apple.com
                    let errorAlert = UIAlertController(title: "Error!", message: "Please select no more than 7 courses", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The error alert occured.")
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
        }
        else if iscourse < 7 {
            // Send alert if the user picks an course that isn't in the database
            // Source: developer.apple.com
            let errorAlert = UIAlertController(title: "Error!", message: "One or more of your courses are not in the course bank. Please only select courses in the course bank.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else {
            
           // call the user uid to set the value of his/her/their course(s)
           // Source: https://stackoverflow.com/questions/43630170/value-of-type-viewcontroller-has-no-member-ref-with-firebase
           guard let user = Auth.auth().currentUser else { return }
           let userUID = user.uid
           let db = Firestore.firestore()
           let ref = db.collection("users").document(userUID)
           
           var i = 0
            
            while i < 7 {
                let courseNum = i + 1
                let courseName = "course\(String(courseNum))"
                ref.updateData([
                   courseName: coursesSelected[i]
                ])
                i = i + 1
            }
            
            self.goToUserProfileScreen()
        }
    }
    
    override func viewDidLoad() {
        getUserData()
        getTableData()
        coursesSearchData1 = coursesData
        coursesSearchData2 = coursesData
        coursesSearchData3 = coursesData
        coursesSearchData4 = coursesData
        coursesSearchData5 = coursesData
        coursesSearchData6 = coursesData
        coursesSearchData7 = coursesData
        course1TableView.alpha = 0
        course1TableView.delegate = self
        course1TableView.dataSource = self
        course2TableView.alpha = 0
        course2TableView.delegate = self
        course2TableView.dataSource = self
        course3TableView.alpha = 0
        course3TableView.delegate = self
        course3TableView.dataSource = self
        course4TableView.alpha = 0
        course4TableView.delegate = self
        course4TableView.dataSource = self
        course5TableView.alpha = 0
        course5TableView.delegate = self
        course5TableView.dataSource = self
        course6TableView.alpha = 0
        course6TableView.delegate = self
        course6TableView.dataSource = self
        course7TableView.alpha = 0
        course7TableView.delegate = self
        course7TableView.dataSource = self
        course1TextField.delegate = self
        course2TextField.delegate = self
        course3TextField.delegate = self
        course4TextField.delegate = self
        course5TextField.delegate = self
        course6TextField.delegate = self
        course7TextField.delegate = self
        coursesTextFieldsArray = [course1TextField, course2TextField, course3TextField, course4TextField, course5TextField, course6TextField, course7TextField]
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getTableData(){
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
                    let code = i["course-code"] as! String
                    let name = i["course-name"] as! String
                    let offering = i["currently-offering"] as! Bool
                    if offering == true{
                        self?.coursesData.append("\(code) \(name)")
                    }
                }
                self?.course1TableView.reloadData()
                self?.course2TableView.reloadData()
                self?.course3TableView.reloadData()
                self?.course4TableView.reloadData()
                self?.course5TableView.reloadData()
                self?.course6TableView.reloadData()
                self?.course7TableView.reloadData()
            }
        }
    }
    
    func getUserData(){
        guard let user = Auth.auth().currentUser else {return}
        let userUID = user.uid
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userUID)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                var j = 1
                while j < 8{
                    if document.get("course"+String(j)) != nil{
                        self.coursesTextFieldsArray[j-1].text = (document.get("course"+String(j)) as! String)
                    }
                    else{
                        self.coursesTextFieldsArray[j-1].text = "N/A"
                    }
                    j+=1
                }
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
extension Courses_IsEditing_ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == course1TextField{
            if string.isEmpty {
                coursesSearch1 = String(textField.text!.dropLast())
                coursesSearchData1 = coursesData
            }
            else
            {
                coursesSearch1=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch1.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData1.removeAll(keepingCapacity: true)
                coursesSearchData1 = filteredArray
            }
            else
            {
                coursesSearchData1=coursesData
            }
            self.course1TableView.reloadData()
        }
        else if textField == course2TextField{
            if string.isEmpty {
                coursesSearch2 = String(textField.text!.dropLast())
                coursesSearchData2 = coursesData
            }
            else
            {
                coursesSearch2=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch2.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData2.removeAll(keepingCapacity: true)
                coursesSearchData2 = filteredArray
            }
            else
            {
                coursesSearchData2=coursesData
            }
            self.course2TableView.reloadData()
        }
        else if textField == course3TextField{
            if string.isEmpty {
                coursesSearch3 = String(textField.text!.dropLast())
                coursesSearchData3 = coursesData
            }
            else
            {
                coursesSearch3=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch3.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData3.removeAll(keepingCapacity: true)
                coursesSearchData3 = filteredArray
            }
            else
            {
                coursesSearchData3=coursesData
            }
            self.course3TableView.reloadData()
        }
        else if textField == course4TextField{
            if string.isEmpty {
                coursesSearch4 = String(textField.text!.dropLast())
                coursesSearchData4 = coursesData
            }
            else
            {
                coursesSearch4=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch4.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData4.removeAll(keepingCapacity: true)
                coursesSearchData4 = filteredArray
            }
            else
            {
                coursesSearchData4=coursesData
            }
            self.course4TableView.reloadData()
        }
        else if textField == course5TextField{
            if string.isEmpty {
                coursesSearch5 = String(textField.text!.dropLast())
                coursesSearchData5 = coursesData
            }
            else
            {
                coursesSearch5=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch5.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData5.removeAll(keepingCapacity: true)
                coursesSearchData5 = filteredArray
            }
            else
            {
                coursesSearchData5=coursesData
            }
            self.course5TableView.reloadData()
        }
        else if textField == course6TextField{
            if string.isEmpty {
                coursesSearch6 = String(textField.text!.dropLast())
                coursesSearchData6 = coursesData
            }
            else
            {
                coursesSearch6=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch6.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData6.removeAll(keepingCapacity: true)
                coursesSearchData6 = filteredArray
            }
            else
            {
                coursesSearchData6=coursesData
            }
            self.course6TableView.reloadData()
        }
        else if textField == course7TextField{
            if string.isEmpty {
                coursesSearch7 = String(textField.text!.dropLast())
                coursesSearchData7 = coursesData
            }
            else
            {
                coursesSearch7=textField.text!+string
            }
            
            var filteredArray:[String] = []
            for i in coursesData {
                if i.lowercased().contains(coursesSearch7.lowercased()){
                    filteredArray.append(i)
                }
            }
            if filteredArray.count > 0
            {
                coursesSearchData7.removeAll(keepingCapacity: true)
                coursesSearchData7 = filteredArray
            }
            else
            {
                coursesSearchData7=coursesData
            }
            self.course7TableView.reloadData()
        }
        return true
    }
    
    //https://stackoverflow.com/questions/45908469/how-do-you-show-table-view-only-when-search-bar-is-clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == course1TextField {
            course1TableView.alpha = 1
        }
        else if textField == course2TextField{
            course2TableView.alpha = 1
        }
        else if textField == course3TextField{
            course3TableView.alpha = 1
        }
        else if textField == course4TextField{
            course4TableView.alpha = 1
        }
        else if textField == course5TextField{
            course5TableView.alpha = 1
        }
        else if textField == course6TextField{
            course6TableView.alpha = 1
        }
        else if textField == course7TextField{
            course7TableView.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == course1TextField {
            course1TableView.alpha = 0
        }
        else if textField == course2TextField{
            course2TableView.alpha = 0
        }
        else if textField == course3TextField{
            course3TableView.alpha = 0
        }
        else if textField == course4TextField{
            course4TableView.alpha = 0
        }
        else if textField == course5TextField{
            course5TableView.alpha = 0
        }
        else if textField == course6TextField{
            course6TableView.alpha = 0
        }
        else if textField == course7TextField{
            course7TableView.alpha = 0
        }
    }
}

extension Courses_IsEditing_ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        if tableView == course1TableView{
            return coursesSearchData1.count
        }
        else if tableView == course2TableView{
            return coursesSearchData2.count
        }
        else if tableView == course3TableView{
            return coursesSearchData3.count
        }
        else if tableView == course4TableView{
            return coursesSearchData4.count
        }
        else if tableView == course5TableView{
            return coursesSearchData5.count
        }
        else if tableView == course6TableView{
            return coursesSearchData6.count
        }
        else if tableView == course7TableView{
            return coursesSearchData7.count
        }
        else{
            print("Error")
            return 1
        }
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == course1TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData1[indexPath.row]
            return cell
        }
        else if tableView == course2TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData2[indexPath.row]
            return cell
        }
        else if tableView == course3TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData3[indexPath.row]
            return cell
        }
        else if tableView == course4TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData4[indexPath.row]
            return cell
        }
        else if tableView == course5TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData5[indexPath.row]
            return cell
        }
        else if tableView == course6TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData6[indexPath.row]
            return cell
        }
        else if tableView == course7TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData7[indexPath.row]
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
}

// Fills the text field with the name of the cell the user clicked on if it has not already been selected as another course
extension Courses_IsEditing_ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
        coursesSelected = [course1TextField.text!, course2TextField.text!, course3TextField.text!, course4TextField.text!, course5TextField.text!, course6TextField.text!, course7TextField.text!]
        
        var courseRepeat = false
        
        for i in coursesSelected {
            if i == cell.name.text{
                courseRepeat = true
            }
        }
        
        if courseRepeat == false{
            if tableView == course1TableView{
                course1TextField.text = cell.name.text
            }
            else if tableView == course2TableView{
                course2TextField.text = cell.name.text
            }
            else if tableView == course3TableView{
                course3TextField.text = cell.name.text
            }
            else if tableView == course4TableView{
                course4TextField.text = cell.name.text
            }
            else if tableView == course5TableView{
                course5TextField.text = cell.name.text
            }
            else if tableView == course6TableView{
                course6TextField.text = cell.name.text
            }
            else if tableView == course7TableView{
                course7TextField.text = cell.name.text
            }
        }
        else{
            let errorAlert = UIAlertController(title: "Error!", message: "You've already selected this course. Please only select the same course only once.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The error alert occured.")
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
}

//
//  Study Spot IsEditing ViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/25/21.
//
