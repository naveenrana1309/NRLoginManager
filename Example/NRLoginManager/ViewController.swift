//
//  ViewController.swift
//  NRLoginManager
//
//  Created by naveenrana1309 on 04/28/2018.
//  Copyright (c) 2018 naveenrana1309. All rights reserved.
//

import UIKit
import NRLoginManager

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        NRLoginManager.shared.login(type: .facebook) { (user, error) in
            if error == nil {
                self.welcomeLabel.text = user!.name
                print(user!)
            }
        }
    }

    @IBAction func googleButtonPressed(_ sender: UIButton) {
        NRLoginManager.shared.clientID = "626400980954-m4gsqsqm3j7a4m8g8jmj316suojhf4hh.apps.googleusercontent.com"
        NRLoginManager.shared.login(type: .google) { (user, error) in
            if error == nil {
                self.welcomeLabel.text = user!.name
                print(user!)
            }

        }
    }

}



