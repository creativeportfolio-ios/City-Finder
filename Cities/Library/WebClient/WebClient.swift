//
//  WebClient.swift
//  WebClient-Swift
//
//

import UIKit
import Foundation
import Alamofire

var kInternetConnectionMessage = "Please check your internet connection"
var kTryAgainLaterMessage = "Please try again later"
var kErrorDomain = "Error"
var kDefaultErrorCode = 1234

var kSuccessKey = "status"
var kMessageKey = "message"
var kDataKey = "data"

typealias MultipartFormDataBlock = (_ multipartFormData : MultipartFormData?) -> Void
typealias CompletionBlock = (_ response: Dictionary<String, Any>?, _ error: Error?) -> Void
typealias DownloadCompletionBlock = (_ filePath: String?, _ fileData: Data?, _ error: Error?) -> Void
typealias ResponseHandler = (_ response:DataResponse<Any>) -> Void

class WebClient: NSObject {

    //MARK: - Request
    class func requestWithUrl(url: String, method: String? = "GET", parameters: Dictionary<String, Any>?, headers: HTTPHeaders? = nil, completion: CompletionBlock?) -> DataRequest? {
        
        return Alamofire.request(url, method: HTTPMethod(rawValue: method!)!, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                if (response.response?.statusCode ?? 0) == 200 {
                    switch response.result {
                    case .success(let value):
                        handleResponse(response: value, completion: completion)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion?(nil, error)
                    }
                }
                else {
                    print(response.error!.localizedDescription)
                    completion?(nil, response.error)
                }
                
        }
    }

    
    //MARK: - Handle Response
    class func handleResponse(response: Any?, completion: CompletionBlock?) {
        let error = NSError(domain: kErrorDomain, code: kDefaultErrorCode, userInfo: [NSLocalizedDescriptionKey: kTryAgainLaterMessage])
        if !(response is [AnyHashable: Any]) {
            completion?(nil, error)
        }
        else {
            completion?(response as? Dictionary<String, Any>, nil)
            return
        }
    }
}


