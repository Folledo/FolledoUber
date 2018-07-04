//
//  ViewController.swift
//  FolledoUber
//
//  Created by Samuel Folledo on 7/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

// 1) Firebase Installation
// 2) Login & Signup = Setting up login and sign up with firebase
// 3) The Rider ViewController =
// 4) The Driver ViewController
// 5) Sharing the Driver's Location with the Driver

import UIKit
import FirebaseAuth //2 //10mins

class ViewController: UIViewController {
    
    @IBOutlet weak var riderLabel: UILabel! //2 //8mins
    @IBOutlet weak var driverLabel: UILabel! //2 //8mind
    @IBOutlet weak var emailTextField: UITextField! //2 //8mins
    @IBOutlet weak var passwordTextField: UITextField! //2 //8mins
    @IBOutlet weak var riderDriverSwitch: UISwitch! //2 //8mins
    @IBOutlet weak var topButton: UIButton! //2 //8mins
    @IBOutlet weak var bottomButton: UIButton! //2 //8mins
    
    var signUpMode = true //2 //11mins
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func topTapped(_ sender: Any) { //2 //8mins
        
        if emailTextField.text == "" || passwordTextField.text == "" { //2 //17mins
            displayAlert(title: "Missing Information", message: "You must provide both an email and password") //2 //21mins
        } else {
            if let email = emailTextField.text { //2 //24mins
                if let password = passwordTextField.text { //2 //24mins
            
            if signUpMode { //2 //22mins //SIGN UP
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in //2 //23mins
                    if error != nil { //2 //24mins
                        self.displayAlert(title: "Error", message: error!.localizedDescription) //2 //24mins
                    } else { //2 //25mins
                        print("Sign Up Success")
                    }
                }) //2 //23mins
            } else { //2 //22mins //LOG IN
                
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in //2 //26mins
                    if error != nil { //2 //26mins
                        self.displayAlert(title: "Error", message: error!.localizedDescription) //2 //26mins
                    } else { //2 //26mins //Dont forget to setup an authentication process
                        print("Log In Success")
                    }
                    
                }
                
            }}}
        }
        
    }
    
    func displayAlert(title: String, message: String) { //2 //18mins
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert) //2 //20mins
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) //2 //20mins
        self.present(alertController, animated: true, completion: nil) //2 //20mins
    }
    
//bottomTapped method
    @IBAction func bottomTapped(_ sender: Any) { //2 //8mins
        if signUpMode { //2 //15mins
            topButton.setTitle("Log In", for: .normal) //2 //15mins
            bottomButton.setTitle("Switch to Sign Up", for: .normal) //2 //15mins
            riderLabel.isHidden = true //2 //15mins
            driverLabel.isHidden = true //2 //15mins
            riderDriverSwitch.isHidden = true //2 //15mins
            signUpMode = false //2 //15mins
        } else { //2 //15mins
            topButton.setTitle("Sign Up", for: .normal) //2 //15mins
            bottomButton.setTitle("Switch to Log In", for: .normal) //2 //15mins
            riderLabel.isHidden = false //2 //15mins
            driverLabel.isHidden = false //2 //15mins
            riderDriverSwitch.isHidden = false //2 //15mins
            signUpMode = true //2 //15mins
        } //2 //15mins
    } //2 //15mins
    

}

