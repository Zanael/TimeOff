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


enum PickerType: Int {
    case date = 1
    case fromDate = 2
    case toDate = 3
}


class AddDetailTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    weak var timeOffTypeTableViewController: TimeOffTypeTableViewController?
    
    var isDatePickerHidden = true
    var isFromDatePickerHidden = true
    var isToDatePickerHidden = true
    
    var keyboardHeight = 0
    var showKeyboard = false
    
    // NOTE: Можно вынести type в enum : String, и получать String значение через rawValue.
    var type = ""
    
    // NOTE: Подумать как вынести логику валидации.
    var create = false
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var textViewCommentary: UITextView!
    
    @IBOutlet weak var typeTitle: UILabel!
    
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var fromDateDetail: UILabel!
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var toDateDetail: UILabel!
    @IBOutlet weak var toDate: UIDatePicker!
    
    
    
    //MARK: - IBActions
    
    @IBAction func datePickerValue(sender: UIDatePicker) {
        datePickerChanged(pickerType: .date)
    }
    
    @IBAction func fromDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .fromDate)
    }
    
    @IBAction func toDatePickerValue(_ sender: UIDatePicker) {
        datePickerChanged(pickerType: .toDate)
    }
    
    @IBAction func unwindToAddTimeOff(segue: UIStoryboardSegue) {
        
        setTextViewColor(isValid: true)
        self.isFullTimeOff()
        
        //NOTO: Встречал такую конструкцию, желательно придумать более элегантное решение.
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func createTimeOff(_ sender: Any) {
        
        guard
            self.type == ""
            else {
                setTextViewColor(isValid: false)
                //сюда добавить аллерт в будущем
                return
            }

        
        //NOTE: Мне кажется тут немного дичи)
        //1: Выделить логику проверок из метода shouldPerformSegue
        //2: Создать extension для DateFormatter
        //3: Вынести константы url
        //4: Повторяющиеся вызовы getAlert с кучей параметров вынести в один метод
        //5: Убрать "_ sender: Any" из параметров функций IBAction
        //6: Облегчить IBAction, вынеся логику запроса Alamofire в отдельный extension
        
        self.create = true
        
        if shouldPerformSegue(withIdentifier: "unwindToMainSeague", sender: nil) {
            
            self.view.endEditing(true)
            
            self.startProgressHUD()
            
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

    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureDatePickers()
        configureKeyboard()
    }
    
    
    
    // MARK: - Configure
    
    fileprivate func configureTextView() {
        
        self.textViewCommentary.isEditable = true
    }
    
    fileprivate func configureDatePickers() {
        
        let ruLocale = NSLocale.init(localeIdentifier: "ru_RU") as Locale as Locale
        
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = ruLocale
        
        self.fromDate.datePickerMode = .time
        self.fromDate.locale = ruLocale
        
        self.toDate.datePickerMode = .time
        self.toDate.locale = ruLocale
        
        datePickerChanged(pickerType: .date)
        datePickerChanged(pickerType: .fromDate)
        datePickerChanged(pickerType: .toDate)
    }
    
    fileprivate func configureKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // NOTE: Можно так:
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
    }
    

    
    // MARK: - Private
    
    /// Метод для расчета рабочего времени?
    fileprivate func isFullTimeOff() {
        
        if self.type == "fullMinus" {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            self.fromDateDetail.text = "08:30"
            self.toDateDetail.text = "17:30"
        }
    }
}



// MARK: - Navigation

extension AddDetailTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
        if let identifier = identifier, identifier == "unwindToMainSeague" {
            if !self.create {
                return false
            }
        }
        return true
    }
}



// MARK: - UITableViewDelegate

extension AddDetailTableViewController: UITableViewDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            switch indexPath.section {
            case 0:
                // NOTE: Это конечно надо выделить в другой метод.
                self.performSegue(withIdentifier: "SelectTypeSeague", sender: nil)
            case 1:
                self.toggleDatepicker(pickerType: .date)
            case 2:
                // NOTE: Можно вынести type в enum : String, и получать String значение через rawValue.
                if self.type != "fullMinus" {
                    self.toggleDatepicker(pickerType: .fromDate)
                }
            case 3:
                // NOTE: Можно вынести type в enum : String, и получать String значение через rawValue.
                if self.type != "fullMinus" {
                    self.toggleDatepicker(pickerType: .toDate)
                }
            default:
                break
            }
        }
    }
}



// MARK: - UITableViewDataSource

extension AddDetailTableViewController: UITableViewDataSource {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //NOTE: Не совсем понял логику, возможно, можно оптимизировать.
        
        if indexPath.row == 1 {
            switch indexPath.section {
            case 1:
                if self.isDatePickerHidden {
                    return 0
                }
            case 1:
                if self.isFromDatePickerHidden {
                    return 0
                }
            case 1:
                if self.isToDatePickerHidden {
                    return 0
                }
            default:
                break
            }
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}



// MARK: - Keyboard

extension AddDetailTableViewController {
    
    //NOTE: Можно так:
    
    /*
    func keyboardDidShow(_ notification: Notification) {
        let
        info = notification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    */
    
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
}



// MARK: - DatePickers

extension AddDetailTableViewController {
    
    //TODO: Сделать extension DateFormatter и выделить enum для типа форматера.
    
    func datePickerChanged(pickerType: PickerType) {
        
        let formatter = DateFormatter()
        
        switch pickerType {
        case .date:
            formatter.dateFormat = "dd-MM-yyyy"
            self.dateDetail.text = formatter.string(from: self.datePicker.date)
        case .fromDate:
            formatter.dateFormat = "HH:mm"
            self.fromDateDetail.text = formatter.string(from: self.fromDate.date)
        case .toDate:
            formatter.dateFormat = "HH:mm"
            self.toDateDetail.text = formatter.string(from: self.toDate.date)
        }
    }
    
    func toggleDatepicker(pickerType: PickerType) {
        
        switch pickerType {
        case .date:
            self.isDatePickerHidden = !self.isDatePickerHidden
        case .fromDate:
            self.isFromDatePickerHidden = !self.isFromDatePickerHidden
        case .toDate:
            self.isToDatePickerHidden = !self.isToDatePickerHidden
        }
        
        //NOTO: Встречал такую конструкцию, желательно придумать более элегантное решение.
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}



// MARK: - MBProgressHUD

extension AddDetailTableViewController {
    
    fileprivate func startProgressHUD() {
        
        makeProgressHUD().showAdded(to: view, animated: true)
    }
    
    fileprivate func makeProgressHUD() -> MBProgressHUD {
        
        let loadingNotification = MBProgressHUD()
        
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.isUserInteractionEnabled = false
        loadingNotification.bezelView.color = UIColor.black
        loadingNotification.contentColor = UIColor.white
        loadingNotification.bezelView.style = .solidColor
        loadingNotification.backgroundView.blurEffectStyle = .extraLight
        
        return loadingNotification
    }
}



// MARK: - Text validation

extension AddDetailTableViewController {
    
    fileprivate func setTextViewColor(isValid: Bool) {
        self.typeTitle.textColor = isValid ? UIColor.black : UIColor.red
    }
}



// MARK: - AlertController

extension AddDetailTableViewController {
    
    fileprivate func getAlert(title: String, message: String, statusCode: Int) -> UIAlertController {
        
        // NOTE: Можно подумать как сделать более элегантно.
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        return makeAlertController()
    }
    
    fileprivate func makeAlertController() -> UIAlertController {
        
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
            }
        }))
        
        return alert;
    }
}
