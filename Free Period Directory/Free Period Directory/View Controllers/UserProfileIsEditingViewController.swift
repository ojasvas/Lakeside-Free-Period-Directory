//
//  UserProfileIsEditingViewController.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 5/17/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserProfileIsEditingViewController: UIViewController{

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var free1TextField: UITextField!
    
    @IBOutlet weak var free2TextField: UITextField!
    
    @IBOutlet weak var free3TextField: UITextField!
    
    @IBOutlet weak var favoriteStudySpotTextField: UITextField!
    
    @IBOutlet weak var course1TextField: UITextField!
    
    @IBOutlet weak var course2TextField: UITextField!
    
    @IBOutlet weak var course3TextField: UITextField!
    
    @IBOutlet weak var course4TextField: UITextField!
    
    @IBOutlet weak var course5TextField: UITextField!
    
    @IBOutlet weak var course6TextField: UITextField!
    
    @IBOutlet weak var course7TextField: UITextField!
    
    @IBOutlet weak var interest1TextField: UITextField!
    
    @IBOutlet weak var interest2TextField: UITextField!
    
    @IBOutlet weak var interest3TextField: UITextField!
    
    @IBOutlet weak var freeSearchTableView: UITableView!
    
    @IBOutlet weak var studySpotSearchTableView: UITableView!
    
    @IBOutlet weak var coursesSearchTableView: UITableView!
    
    @IBOutlet weak var interestsSearchTableView: UITableView!
    var freesSearch = ""
    
    var coursesSearch = ""
    
    var studySpotSearch = ""
    
    var interestsSearch = ""
    
    private var freesData = [String]()
    
    private var coursesData = [String]()
    
    private var studySpotData = [String]()
    
    private var interestsData = [String]()
    
    private var freesSearchData = [String]()
    
    private var coursesSearchData = [String]()
    
    private var studySpotSearchData = [String]()
    
    private var interestsSearchData = [String]()
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        goToHomeScreen()
    }
    
    @IBAction func doneEditingTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        freesData = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth"]
        freesSearchData = freesData
        getTableData()
        coursesSearchData = coursesData
        studySpotSearchData = studySpotData
        interestsSearchData = interestsData
        freeSearchTableView.alpha = 0
        studySpotSearchTableView.alpha = 0
        coursesSearchTableView.alpha = 0
        interestsSearchTableView.alpha = 0
        freeSearchTableView.delegate = self
        studySpotSearchTableView.delegate = self
        coursesSearchTableView.delegate = self
        interestsSearchTableView.delegate = self
        freeSearchTableView.dataSource = self
        studySpotSearchTableView.dataSource = self
        coursesSearchTableView.dataSource = self
        interestsSearchTableView.dataSource = self
        free1TextField.delegate = self
        free2TextField.delegate = self
        free3TextField.delegate = self
        favoriteStudySpotTextField.delegate = self
        course1TextField.delegate = self
        course2TextField.delegate = self
        course3TextField.delegate = self
        course4TextField.delegate = self
        course5TextField.delegate = self
        course6TextField.delegate = self
        course7TextField.delegate = self
        interest1TextField.delegate = self
        interest2TextField.delegate = self
        interest3TextField.delegate = self
        super.viewDidLoad()
        freeSearchTableView.reloadData()
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
                self?.coursesSearchTableView.reloadData()
            }
        }
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
                self?.interestsSearchTableView.reloadData()
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
extension UserProfileIsEditingViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == free1TextField || textField == free2TextField || textField == free3TextField{
            if string.isEmpty {
                freesSearch = String(textField.text!.dropLast())
                freeSearchTableView.alpha = 0
            }
            else
            {
                freesSearch=textField.text!+string
            }

            let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", freesSearch)
            let filteredArray = (freesData as NSArray).filtered(using: predicate)

            if filteredArray.count > 0
            {
                freesSearchData.removeAll(keepingCapacity: true)
                freesSearchData = filteredArray as! [String]
            }
            else
            {
                freesSearchData=freesData
            }
            self.freeSearchTableView.reloadData()
        }
        
        else if textField == course1TextField || textField == course2TextField || textField == course3TextField || textField == course4TextField || textField == course5TextField || textField == course6TextField || textField == course7TextField{
            if string.isEmpty {
                coursesSearch = String(textField.text!.dropLast())
                coursesSearchTableView.alpha = 0
            }
            else
            {
                coursesSearch=textField.text!+string
            }

            let predicate=NSPredicate(format: "CONTAINS[cd] %@", coursesSearch)
            let filteredArray = (coursesData as NSArray).filtered(using: predicate)

            if filteredArray.count > 0
            {
                coursesSearchData.removeAll(keepingCapacity: true)
                coursesSearchData = filteredArray as! [String]
            }
            else
            {
                coursesSearchData=coursesData
            }
            self.coursesSearchTableView.reloadData()
        }
        
        else if textField == favoriteStudySpotTextField{
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
        }
        
        else if textField == interest1TextField || textField == interest2TextField || textField == interest3TextField{
            if string.isEmpty {
                interestsSearch = String(textField.text!.dropLast())
                interestsSearchTableView.alpha = 0
            }
            else
            {
                interestsSearch=textField.text!+string
            }

            let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", interestsSearch)
            let filteredArray = (interestsData as NSArray).filtered(using: predicate)

            if filteredArray.count > 0
            {
                interestsSearchData.removeAll(keepingCapacity: true)
                interestsSearchData = filteredArray as! [String]
            }
            else
            {
                interestsSearchData=interestsData
            }
            self.interestsSearchTableView.reloadData()
        }
        return true
    }
    
    //https://stackoverflow.com/questions/45908469/how-do-you-show-table-view-only-when-search-bar-is-clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == free1TextField || textField == free2TextField || textField == free3TextField{
            freeSearchTableView.alpha = 1
        }
        
        else if textField == course1TextField || textField == course2TextField || textField == course3TextField || textField == course4TextField || textField == course5TextField || textField == course6TextField || textField == course7TextField{
            coursesSearchTableView.alpha = 1
        }
        
        else if textField == favoriteStudySpotTextField{
            studySpotSearchTableView.alpha = 1
        }
        else if textField == interest1TextField || textField == interest2TextField || textField == interest3TextField{
            interestsSearchTableView.alpha = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == free1TextField || textField == free2TextField || textField == free3TextField{
            freeSearchTableView.alpha = 0
        }
        
        else if textField == course1TextField || textField == course2TextField || textField == course3TextField || textField == course4TextField || textField == course5TextField || textField == course6TextField || textField == course7TextField{
            coursesSearchTableView.alpha = 0
        }
        
        else if textField == favoriteStudySpotTextField{
            studySpotSearchTableView.alpha = 0
        }
        else if textField == interest1TextField || textField == interest2TextField || textField == interest3TextField{
            interestsSearchTableView.alpha = 0
        }
    }
}

extension UserProfileIsEditingViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        switch tableView {
        case freeSearchTableView:
            return freesSearchData.count
        case studySpotSearchTableView:
            return studySpotSearchData.count
        case coursesSearchTableView:
            return coursesSearchData.count
        case interestsSearchTableView:
            return interestsSearchData.count
        default:
            print("Error")
            return 1
        }
    }
    
    //TableVIew setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch tableView {
        case freeSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "freeCell")!  as! Cell
            cell.name.text = freesSearchData[indexPath.row]
            return cell
        case studySpotSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "studySpotCell")!  as! Cell
            cell.name.text = studySpotSearchData[indexPath.row]
            return cell
        case coursesSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesCell")!  as! Cell
            cell.name.text = coursesSearchData[indexPath.row]
            return cell
        case interestsSearchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell")!  as! Cell
            cell.name.text = interestsSearchData[indexPath.row]
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
}

extension UserProfileIsEditingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
        if tableView == freeSearchTableView{
            guard let cell = tableView.cellForRow(at: indexPath)  as? Cell else {return}
            
            free1TextField.text = cell.name.text
            
        }
        
        else if tableView == studySpotSearchTableView{
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
            
            favoriteStudySpotTextField.text = cell.name.text
            
        }
        
        else if tableView == coursesSearchTableView{
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
            
            course1TextField.text = cell.name.text
            
        }
        
        else if tableView == interestsSearchTableView{
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {return}
            
            interest1TextField.text = cell.name.text
            
        }
    }
}

