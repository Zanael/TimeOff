//
//  TimeOffAlert.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 26/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimeOffAlert {
    
    var alert: UIAlertController?
    
    
    init(title: String, message: String, view: UIView) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        self.alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                print("default")
                MBProgressHUD.hide(for: view, animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
    }
    
    func getAlert(title: String, message: String, view: UIView) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                print("default")
                MBProgressHUD.hide(for: view, animated: true)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        return alert;
    }
    
}
