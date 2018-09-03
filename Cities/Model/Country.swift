//
//  Country.swift
//  Cities
//
//

import UIKit

class Country: NSObject {
    
    var ID          : Int16!
    var name        : String!
    var code        : String!
    var continentID : Int16!
    
    init(dict : Dictionary<String, Any>?) {
        ID          = dict?["id"] as? Int16 ?? 0
        name        = dict?["name"] as? String
        code        = dict?["code"] as? String
        continentID = dict?["continent_id"] as? Int16 ?? 0
    }
}
