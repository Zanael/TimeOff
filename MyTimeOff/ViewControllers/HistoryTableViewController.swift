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
    
    // MARK: - Properties
    
    var timeOffs = [Detail]()
    var index: Int = -1
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureRefreshControl()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        self.tableView.reloadData()
//        self.getMyTimeOffs()
//    }
    
    
    
    // MARK: - Configure
    
    fileprivate func configureTableView() {
        
        tableView.register(UINib(nibName: "HistoryTableCell", bundle: nil),
                           forCellReuseIdentifier: "HistoryCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    fileprivate func configureRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Загрузка...")
        refreshControl.addTarget(self, action: #selector(self.getMyTimeOffs), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    
    
    // MARK: - Private
    
    //NOTE: Возможно разбить на методы и назвать ReloadData() ?
    @objc func getMyTimeOffs(refreshControl: UIRefreshControl) {
        //self.startProgressHUD()
        
        //NOTE: url можно вынести в struct Constants
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
}



// MARK: - UITableViewDelegate

extension HistoryTableViewController: UITableViewDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.index = indexPath.row
        
        //NOTE: все символьные названия лучше выносить в константы.
        self.performSegue(withIdentifier: "detailTimeOffSeague", sender: nil)
    }
}



// MARK: - UITableViewDataSource

extension HistoryTableViewController: UITableViewDataSource {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeOffs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath) as! HistoryTableViewCell
        
        cell.labelTitle.text = self.timeOffs[indexPath.row].Detail_Title
        cell.labelCreateDate.text = "Дата создания - " + self.timeOffs[indexPath.row].Detail_CreateDate
        
        //NOTE: Возможно заменить Detail_Type на enum : Int и при необходимости получать rawValue?
        switch self.timeOffs[indexPath.row].Detail_Type {
        case 1:
            //fullMinus
            cell.imgType.backgroundColor = UIColor.red
        case 2:
            //halfMinus
            cell.imgType.backgroundColor = UIColor.red
        case 4:
            //fullPlus
            cell.imgType.backgroundColor = UIColor.green
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}



// MARK: - Navigation

extension AddDetailTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //NOTE: Все символьные значения желательно вынести в константы. Например struct Constants.
        if segue.identifier == "detailTimeOffSeague" {
            let viewController: DetailTableViewController = segue.destination as! DetailTableViewController
            viewController.timeOff = self.timeOffs[self.index]
        }
    }
}



// MARK: - AlertController

extension HistoryTableViewController {
    
    fileprivate func getAlert(title: String, message: String) -> UIAlertController {
        
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
            }
        }))
        
        return alert;
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







