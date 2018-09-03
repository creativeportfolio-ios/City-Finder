//
//  City.swift
//  Cities
//
//

import UIKit

class City: NSObject {
    
    var ID          : Int16!
    var countryID   : Int16!
    var name        : String!
    var nameLocal   : String!
    var lat         : Double!
    var lng         : Double!
    var country     : Country!
    
    public class func modelsFromDictionaryArray(array:Array<Any>) -> [City] {
        var models:[City] = []
        for item in array {
            models.append(City(dict: item as? Dictionary<String, Any>))
        }
        return models
    }
    
    init(dict : Dictionary<String, Any>?) {
        
        ID          = dict?["id"] as? Int16 ?? 0
        countryID   = dict?["country_id"] as? Int16 ?? 0
        name        = dict?["name"] as? String
        nameLocal   = dict?["local_name"] as? String
        lat         = dict?["lat"] as? Double ?? 0.0
        lng         = dict?["lng"] as? Double ?? 0.0
        
        if let dictCountry = dict?["country"] as? Dictionary<String,Any> {
            if let strCountry = dictCountry["name"] as? String {
                country = Country(dict: nil)
                country.name = strCountry
            }
        }
    }
}
