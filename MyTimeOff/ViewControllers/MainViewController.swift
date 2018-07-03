//
//  MainViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 05/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var btnFullPlus: UIButton!
    @IBOutlet weak var btnFullMinus: UIButton!
    
    @IBOutlet weak var textViewTimeOffs: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.getMyTimeOffs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getMyTimeOffs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnFullPlusClick(_ sender: Any) {
        self.performSegue(withIdentifier: "AddDetailSeague", sender: nil)
    }
    
    @IBAction func btnFullMinusClick(_ sender: Any) {
        self.performSegue(withIdentifier: "AddDetailSeague", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddDetailSeague" {
//            let viewController:AddDetailTableViewController = segue.destination as! AddDetailTableViewController
//        }
//    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        self.getMyTimeOffs()
    }
    
    func getMyTimeOffs() {
        self.startHUD()
        
        let urlString = "http://13.94.153.86:82/api/TimeOffs?email=" + UserDefaults.standard.string(forKey: "MyTimeOff.Email")!
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString {
            response in switch response.response?.statusCode {
            case 200:
                
                print(response)
                //let timeoff = TimeOff(json: response.result.value as! [String : Any])
                let timeoff = try! JSONDecoder().decode(TimeOff.self, from: response.data!)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.textViewTimeOffs.text = String(format:"%.1f", (timeoff.TimeOff_Count))
                
                
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
}
