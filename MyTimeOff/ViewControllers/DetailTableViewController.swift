//
//  DetailTableViewController.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 28/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import UIKit


class DetailTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var timeOff: Detail?
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var timeOffDate: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var createDate: UILabel!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
    }
    
    
    
    // MARK: - Configure
    
    fileprivate func configureLabels() {
        
        if let timeOff = timeOff {
            
            labelTitle.text = timeOff.Detail_Title
            timeOffDate.text = timeOff.Detail_TimeOffDate
            fromDate.text = timeOff.Detail_FromDate
            toDate.text = timeOff.Detail_ToDate
            tvComment.text = timeOff.Detail_Comment
            createDate.text = timeOff.Detail_CreateDate
            
        } else {
            
            labelTitle.text = ""
            timeOffDate.text = ""
            fromDate.text = ""
            toDate.text = ""
            tvComment.text = ""
            createDate.text = ""
        }
    }
}
