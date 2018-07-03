//
//  TimeOff.swift
//  MyTimeOff
//
//  Created by Andrey Lunev on 26/06/2018.
//  Copyright © 2018 Andrey Lunev. All rights reserved.
//

import Foundation

struct TimeOff: Codable {
    var TimeOff_ID: Int
    var TimeOff_UserID: String
    var TimeOff_Count: Double
    
//    init?(json: [String: Any]) {
//        guard let TimeOff_ID = json["TimeOff_ID"] as? Int,
//            let TimeOff_UserID = json["TimeOff_UserID"] as? String,
//            let TimeOff_Count = json["TimeOff_Count"] as? Double else {
//                return nil
//        }
//        self.TimeOff_ID = TimeOff_ID
//        self.TimeOff_UserID = TimeOff_UserID
//        self.TimeOff_Count = TimeOff_Count
//    }
}
