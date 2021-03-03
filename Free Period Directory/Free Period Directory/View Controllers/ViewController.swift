//
//  ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/20/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        
        ref.child("someid/name").setValue("Mike")
    }


}

