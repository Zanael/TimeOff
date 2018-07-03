//
//  AddDetailTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 25/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AddDetailTableViewController: UITableViewController {

    @IBOutlet weak var textViewCommentary: UITextView!
    
    @IBOutlet weak var typeTitle: UILabel!
    
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var fromDateDetail: UILabel!
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var toDateDetail: UILabel!
    @IBOutlet weak var toDate: UIDatePicker!
    
    var datePickerHidden = true
    var fromDatePickerHidden = true
    var toDatePickerHidden = true
    
    var keyboardHeight = 0
    var showKeyboard = false
    
    var type = ""
    
    var create = false
    
    weak var timeOffTypeTableViewController: TimeOffTypeTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textViewCommentary.isEditable = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        self.fromDate.datePickerMode = .time
        self.fromDate.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        self.toDate.datePickerMode = .time
        self.toDate.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        datePickerChanged(picker: 1)
        datePickerChanged(picker: 2)
        datePickerChanged(picker: 3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.datePickerHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        }
        else if self.fromDatePickerHidden && indexPath.section == 2 && indexPath.row == 1 {
            return 0
        }
        else if self.toDatePickerHidden && indexPath.section == 3 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    @IBAction func createTimeOff(_ sender: Any) {
        if self.type == "" {
            self.typeTitle.textColor = UIColor.red
            //сюда добавить аллерт в будущем
            return
        }
        
        self.create = true
        if shouldPerformSegue(withIdentifier: "unwindToMainSeague", sender: nil) {
            
            self.view.endEditing(true)
            
            self.startHUD()
            
            let date = Date()
            let formatter = DateFormatter()
            let formatterHour = DateFormatter()
            formatter.dateFormat = "HH:mm:ss dd-MM-yyyy"
            formatterHour.dateFormat = "HH:mm"
            
            let urlString = "http://13.94.153.86:82/api/TimeOffs?email=" + UserDefaults.standard.string(forKey: "MyTimeOff.Email")! + "&type=" + self.type
                        
            Alamofire.request(urlString, method: .put, parameters: ["Detail_TimeOffDate": "00:00:00 " + self.dateDetail.text!, "Detail_CreateDate":  formatter.string(from: date), "Detail_FromDate":  formatter.string(from: self.fromDate.date), "Detail_ToDate":  formatter.string(from: self.toDate.date), "Detail_Comment": self.textViewCommentary.text], encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in switch response.response?.statusCode {
                case 200:
                    
                    print(response)
                    self.present(self.getAlert(title: "Данные добавлены.", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                    
                case 500:
                    print("Error 500")
                    self.present(self.getAlert(title: "Ошибка 500", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                case .none:
                    print("Error none")
                    self.present(self.getAlert(title: "Ошибка неизвестна", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                case .some(_):
                    print("Error some")
                    self.present(self.getAlert(title: "Еще какая-то ошибка", message: "", statusCode: (response.response?.statusCode)!), animated: true, completion: nil)
                }
            }
        }
        else {
            print("NO")
        }
    }
    
    func datePickerChanged (picker: Int) {
        if(picker == 1) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.dateDetail.text = formatter.string(from: self.datePicker.date)
        }
        else if(picker == 2) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.fromDateDetail.text = formatter.string(from: self.fromDate.date)
        }
        else if(picker == 3) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.toDateDetail.text = formatter.string(from: self.toDate.date)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "SelectTypeSeague", sender: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            self.toggleDatepicker(picker: 1)
        }
        else if indexPath.section == 2 && indexPath.row == 0
                && self.type != "fullMinus" {
            self.toggleDatepicker(picker: 2)
        }
        else if indexPath.section == 3 && indexPath.row == 0
                && self.type != "fullMinus" {
            self.toggleDatepicker(picker: 3)
        }
    }
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged(picker: 1)
    }
    
    @IBAction func fromDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(picker: 2)
    }
    
    @IBAction func toDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(picker: 3)
    }
    
    func toggleDatepicker(picker: Int) {
        
        if(picker == 1) {
            self.datePickerHidden = !self.datePickerHidden
        }
        else if(picker == 2) {
            self.fromDatePickerHidden = !self.fromDatePickerHidden
        }
        else if(picker == 3) {
            self.toDatePickerHidden = !self.toDatePickerHidden
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.showKeyboard == false {
            self.view.frame.origin.y -= 0
            self.showKeyboard = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.showKeyboard == true {
            self.view.frame.origin.y += 0
            self.showKeyboard = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "unwindToMainSeague" {
                if self.create == false {
                    return false
                }
            }
        }
        return true
    }
    
    func isFullTimeOff() {
        if self.type == "fullMinus" {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            self.fromDateDetail.text = "08:30"
            self.toDateDetail.text = "17:30"
        }
    }
    
    func getAlert(title: String, message: String, statusCode: Int) -> UIAlertController {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")

                if statusCode == 200 {
                    self.performSegue(withIdentifier: "unwindToMainSeague", sender: nil)
                }
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
    
    @IBAction func unwindToAddTimeOff(segue: UIStoryboardSegue) {
        self.typeTitle.textColor = UIColor.black
        self.isFullTimeOff()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


