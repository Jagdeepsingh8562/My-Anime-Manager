//
//  SeasonHelper.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

class SeasonHelper {
    
    
    
    class func currentYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        return yearString
    }

     class func currentSeason() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month
        switch month {
        case 12,1,2: return "winnter"
        case 3,4,5: return "spring"
        case 6,7,8: return "summer"
        case 9,10,11: return "fall"
        default: return ""
        }
    }
}
