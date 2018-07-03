//
//  ViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 05/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "MyTimeOff"
    static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
    
    var passwordItems: [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    @IBOutlet weak var LoginView: UIView!
    
    weak var loginEmbedViewController: LoginEmbedViewController?
    
    var keyboardHeight = 0
    var showKeyboard = false
    var hasLogin = false
    
    var isLogin = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginEmbedViewController") as! LoginEmbedViewController
        
        viewController.loginEmbedDelegate = self
        
        self.loginEmbedViewController = viewController
        
        addChildViewController(loginEmbedViewController!)
        
    self.LoginView.addSubview((self.loginEmbedViewController?.view)!)
        viewController.view.frame = view.bounds
        viewController.view.frame = CGRect(x:0, y: 0, width:self.LoginView.frame.width, height:198)

        loginEmbedViewController?.didMove(toParentViewController: self)
        view.bringSubview(toFront: LoginView)
        
        // Shadow and Radius for Circle Button
        self.LoginView.layer.shadowColor = UIColor.black.cgColor
        self.LoginView.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.LoginView.layer.masksToBounds = false
        self.LoginView.layer.shadowRadius = 3.0
        self.LoginView.layer.shadowOpacity = 0.75
        
        //self.LoginView.layer.cornerRadius = 5.0
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        do {
            let username: String? = UserDefaults.standard.string(forKey: "MyTimeOff.Email") != nil ? UserDefaults.standard.string(forKey: "MyTimeOff.Email") : ""
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            let keychainPassword = try passwordItem.readPassword()
            self.hasLogin = true
            self.loginPressed(login: username!, password: keychainPassword)
        } catch {
            print("Error reading password from keychain - \(error)")
            self.hasLogin = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        do {
            let username: String? = UserDefaults.standard.string(forKey: "MyTimeOff.Email")
            
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username!,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.deleteItem()
            UserDefaults.standard.removeObject(forKey: "MyTimeOff.Email")
            UserDefaults.standard.removeObject(forKey: "MyTimeOff.Password")
        }
        catch {
            print("Error deleting keychain item - \(error)")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.showKeyboard == false {
            self.view.frame.origin.y -= 90
            self.showKeyboard = true
        }
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.showKeyboard == true {
            self.view.frame.origin.y += 90
            self.showKeyboard = false
        }
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                MBProgressHUD.hide(for: self.view, animated: true)
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        return alert;
    }
    
    func startHUD() {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.isUserInteractionEnabled = false
        loadingNotification.bezelView.color = UIColor.black
        loadingNotification.contentColor = UIColor.white
        loadingNotification.bezelView.style = .solidColor
        loadingNotification.backgroundView.blurEffectStyle = .extraLight
    }
    
    @IBAction func clickAuthData(_ sender: Any) {
        if !self.isLogin {
        self.loginEmbedViewController?.tfLogin.text = "test@mail.ru"
        self.loginEmbedViewController?.tfPassword.text = "!Admin123"
            self.isLogin = !self.isLogin
        }
        else if self.isLogin {
            self.loginEmbedViewController?.tfLogin.text = ""
            self.loginEmbedViewController?.tfPassword.text = ""
            self.isLogin = !self.isLogin
        }
    }
}

extension LoginViewController: LoginEmbedDelegate {
    func loginPressed(login: String, password: String) {
        
        UIButton.animate(withDuration: 0.05,
                         animations: {
                            self.loginEmbedViewController?.btnLogin.transform = CGAffineTransform(scaleX: 0.95, y: 0.9)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.05, animations: {
                                self.loginEmbedViewController?.btnLogin.transform = CGAffineTransform.identity
                                self.startHUD()
                            })
        })
        
        let urlString = "http://13.94.153.86:82/Account/Login"
        Alamofire.request(urlString, method: .post, parameters: ["Email": login, "Password": password],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in switch response.response?.statusCode {
            case 200:
                print(response)
                
                if !self.hasLogin {
                UserDefaults.standard.set(login, forKey: "MyTimeOff.Email") //Bool
                UserDefaults.standard.set(password, forKey: "MyTimeOff.Password")  //Integer
                
                do {
                    // This is a new account, create a new keychain item with the account name.
                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                            account: login,
                                                            accessGroup: KeychainConfiguration.accessGroup)
                    
                    // Save the password for the new item.
                    try passwordItem.savePassword(password)
                } catch {
                    print("Error updating keychain - \(error)")
                }
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "LoginToMainSeague", sender: nil)
                break
            case 500:
                print("Error 500")
                self.present(self.getAlert(title: "Ошибка 500", message: ""), animated: true, completion: nil)
            case .none:
                print("Error none")
                self.present(self.getAlert(title: "Ошибка неизвестна", message: ""), animated: true, completion: nil)
            case .some(_):
                print("Error some")
                self.present(self.getAlert(title: "Еще какая-то ошибка", message: ""), animated: true, completion: nil)
            }
        }
    }
}
