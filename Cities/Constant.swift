//
//  Constant.swift
//

import UIKit
import Foundation


//Staging
public let BASE_URL = "http://connect-demo.mobile1.io/square1/connect/v1/"

struct K {

    struct URL {
        static let GET_CITIES                 = BASE_URL + "city"
    }

    //struct: Contains Keys
    struct Key {
        static let Data = "data"
        static let Message = "message"
    }
    
    //struct: Contains All the messages shown to user
    struct Message {
        //Buttons
        static let OK = "OK"
        static let Cancel = "Cancel"
    }
}
