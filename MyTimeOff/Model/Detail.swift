//
//  Detail.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 27/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation

struct Detail: Codable {
    var Detail_ID: Int
    var Detail_TimeOffID: Int
    var Detail_Title: String
    var Detail_Type: Int
    var Detail_Comment: String?
    var Detail_CreateDate: String
    var Detail_TimeOffDate: String
    var Detail_FromDate: String
    var Detail_ToDate: String
    
//    init?(json: [String: Any]) {
//        guard let Detail_ID = json["Detail_ID"] as? Int,
//            let Detail_TimeOffID = json["Detail_TimeOffID"] as? Int,
//            let Detail_Title = json["Detail_Title"] as? String,
//            let Detail_Type = json["Detail_Type"] as? Int,
//            let Detail_Comment = json["Detail_Comment"] as? String,
//            let Detail_CreateDate = json["Detail_CreateDate"] as? String,
//            let Detail_TimeOffDate = json["Detail_TimeOffDate"] as? String
//            else {
//                return nil
//        }
//        self.Detail_ID = Detail_ID
//        self.Detail_TimeOffID = Detail_TimeOffID
//        self.Detail_Title = Detail_Title
//        self.Detail_Type = Detail_Type
//        self.Detail_Comment = Detail_Comment
//        self.Detail_CreateDate = Detail_CreateDate
//        self.Detail_TimeOffDate = Detail_TimeOffDate
//    }
}
