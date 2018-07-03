//
//  LoginEmbedViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 21/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire

protocol LoginEmbedDelegate: class {
    func loginPressed(login :String, password :String)
}

class LoginEmbedViewController: UITableViewController {
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    weak var loginEmbedDelegate: LoginEmbedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tfLogin.text = "test@mail.ru"
        //self.tfPassword.text = "!Admin123"
        self.btnLogin.layer.cornerRadius = 7
        
        // Shadow and Radius for Circle Button
        self.btnLogin.layer.shadowColor = UIColor.black.cgColor
        self.btnLogin.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.btnLogin.layer.masksToBounds = false
        self.btnLogin.layer.shadowRadius = 3.0
        self.btnLogin.layer.shadowOpacity = 0.75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginEmbedDelegate?.loginPressed(login: self.tfLogin.text!, password: self.tfPassword.text!)
    }

    
}
