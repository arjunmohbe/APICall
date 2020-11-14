//
//  ViewController.swift
//  ApiCall
//
//  Created by Lorenzo on 30/10/20.
//

import UIKit


//URL Components (URL: https://mohbe.in/getResponse)
let site_scheme_secure = "https"
let site_host = "mohbe.in"
let path = "/getResponse"

//Request Method (API call method for this request is Get)
let httpMethodGET = "GET"

//Headers 
let header_ContentType_applicationJSON = "application/json"
let authenticationKey = "a5bfc9e07964f8dddeb95fc584cd965d"



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("")
        print("")
        
        let parameters : [String : String] = ["fruit": "Cherries"]
        
        restData(authentication: authenticationKey, apipath: path, filters: parameters, httpMethod: httpMethodGET, JSONData: nil) { (data) in
            print("Data Occured: ", data)
        } failure: { (error) in
            print("Error Occured: ", error)
        }
        
    }

    
    func restData(authentication: String?, apipath: String, filters: [String:String]?, httpMethod: String, JSONData: Data?, success: @escaping (Data) -> (), failure: @escaping (String) -> () ) {

        var component = URLComponents()
        component.scheme = site_scheme_secure
        component.host = site_host
        component.path = apipath
        
        var queryItems = [URLQueryItem]()
        if let filtersPresent = filters {
            for (key, value) in filtersPresent {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        component.queryItems = queryItems
        
        guard let url = component.url else {
            print("URL Failed. \nComponent Description: \(component.debugDescription)");
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = ""
        headers["authKey"] = authenticationKey
        request.allHTTPHeaderFields = headers
        
        print("Url : ", url)
        print("Method : ", request.httpMethod as Any)
        print("Headers : ", headers)
        print("Parameters : ", String(data: JSONData ?? Data(), encoding: .utf8) as Any)
        
        request.httpBody = JSONData
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let r = response as? HTTPURLResponse
            guard let _ = response as? HTTPURLResponse,
                let data = data, error == nil
                else {
                   if   r != nil {
                        failure("Error Occured: \(error.debugDescription)")
                    }
                    else {
                        failure("No response: Server Unreachable")
                    }
                    return
            }
            let responseStr = String(data: data, encoding: .utf8)
            print("Response : ", responseStr ?? "nil")
            success(data)
        }
        task.resume()
    }
}

