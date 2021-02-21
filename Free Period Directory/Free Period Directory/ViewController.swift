//
//  ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/20/21.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        
        ref.child("someid/name").setValue("Mike")
    }


}

