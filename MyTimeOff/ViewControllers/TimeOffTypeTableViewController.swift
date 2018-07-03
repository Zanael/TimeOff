//
//  TimeOffTypeTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit

class TimeOffTypeTableViewController: UITableViewController {
    
    var typeTitle = ""
    var typeValue = ""
    var lastIndexPath: IndexPath = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneType(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToAddTimeOff", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.isSelected)! {
            if !self.lastIndexPath.isEmpty {
                tableView.cellForRow(at: self.lastIndexPath)?.accessoryType = .none
            }
            
            self.lastIndexPath = indexPath
            
            if indexPath.row == 0 {
                self.typeValue = "fullPlus"
            }
            else if indexPath.row == 1 {
                self.typeValue = "fullMinus"
            }
            else if indexPath.row == 2 {
                self.typeValue = "halfMinus"
            }
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.typeTitle = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "unwindToAddTimeOff" {
                let viewController: AddDetailTableViewController = segue.destination as! AddDetailTableViewController
                viewController.typeTitle.text = self.typeTitle
                viewController.type = self.typeValue
            }
        }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 3
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

//}
