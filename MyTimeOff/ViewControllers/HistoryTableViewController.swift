//
//  HistoryTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 27/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class HistoryTableViewController: UITableViewController {
    
    var timeOffs = [Detail]()
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        tableView.register(UINib(nibName: "HistoryTableCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl.addTarget(self, action: #selector(self.getMyTimeOffs), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        self.tableView.reloadData()
//        self.getMyTimeOffs()
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.performSegue(withIdentifier: "detailTimeOffSeague", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeOffs.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTimeOffSeague" {
            let viewController: DetailTableViewController = segue.destination as! DetailTableViewController
            viewController.timeOff = self.timeOffs[self.index]
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath) as! HistoryTableViewCell
        
        cell.labelTitle.text = self.timeOffs[indexPath.row].Detail_Title
        cell.labelCreateDate.text = "Дата создания - " + self.timeOffs[indexPath.row].Detail_CreateDate

        if(self.timeOffs[indexPath.row].Detail_Type == 4) {
            //fullPlus
            cell.imgType.backgroundColor = UIColor.green
        }
        else if(self.timeOffs[indexPath.row].Detail_Type == 1) {
            //fullMinus
            cell.imgType.backgroundColor = UIColor.red
        }
        else if(self.timeOffs[indexPath.row].Detail_Type == 2) {
            //halfMinus
            cell.imgType.backgroundColor = UIColor.red
        }
        
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
     }

    
    // MARK: - Help Methods
    
    @objc func getMyTimeOffs(refreshControl: UIRefreshControl) {
        //self.startHUD()
        
        let urlString = "http://13.94.153.86:82/api/Details?email=" + UserDefaults.standard.string(forKey: "MyTimeOff.Email")!
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString {
            response in switch response.response?.statusCode {
            case 200:
                
                print(response)
                
                self.timeOffs = try! JSONDecoder().decode([Detail].self, from: response.data!)
                print(self.timeOffs)
                //MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
                //self.tableView.refreshControl?.endRefreshing()
                refreshControl.endRefreshing()
                
                
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0;//Choose your custom row height
    }
    
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

}
