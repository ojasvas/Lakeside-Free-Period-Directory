//
//  ViewController.swift
//  Free Period Directory
//
//  Created by Student on 2/20/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        goToSignupScreen()
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        goToLoginScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func goToSignupScreen(){
        let signupViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.signupViewController) as? Signup_ViewController
        view.window?.rootViewController = signupViewController
        view.window?.makeKeyAndVisible()
    }
    func goToLoginScreen(){
        let loginViewController =
            storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? Login_ViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}

