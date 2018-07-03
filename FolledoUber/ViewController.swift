//
//  ViewController.swift
//  FolledoUber
//
//  Created by Samuel Folledo on 7/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

// 1) Firebase Installation
// 2) Login & Signup
// 3) The Rider ViewController
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
        
        
    }
    
    @IBAction func bottomTapped(_ sender: Any) { //2 //8mins
        
        
    }
    

}

