//
//  AuthService.swift
//  Smack
//
//  Created by Pieter Kuijsten on 12/07/2018.
//  Copyright © 2018 Pieter Kuijsten. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            print(response.result.error as Any)
            print(response)
            if response.result.error == nil {
                // SWIFT 4 METHOD
                //                if let json = response.result.value as? Dictionary<String, Any> {
                //                    if let email = json["user"] as? String {
                //                        self.userEmail = email
                //                    }
                //                    if let token = json["token"] as? String {
                //                        self.authToken = token
                //                    }
                //                }
                
                // SWIFTYJSON METHOD
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    print(json)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    print("Login succesvol 1")
                    
                } catch {
                    print("ik zit nu in de catch van LoginUser")
                    print(error)
                }
                
                self.isLoggedIn = true
                print("Login succesvol 2")
                completion(true)
            } else {
                completion(false)
                print("Ik zit in de debugprint van loginUser")
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                print("ik ben nu userdata aan het zetten")
                completion(true)
            } else {
                completion(false)
                print("Ik zit in de debugprint van findUser")
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func setUserInfo(data: Data) {
        do {
            let json = try JSON(data: data)
            let id = json["_id"].stringValue
            let color = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            
            UserDataService.instance.setUserDataService(id: id, color: color, avatarName: avatarName, email: email, name: name)
        } catch {
            print("de error komt van de setUserInfo functie")
            print(error)
        }
    }
    
    func updateUserName(newUserName: String, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "name": newUserName,
            "email": UserDataService.instance.email,
            "avatarName": UserDataService.instance.avatarName,
            "avatarColor": UserDataService.instance.avatarColor
        ]
        
        print(body)
        
        Alamofire.request("\(URL_UPDATE_USERNAME)\(UserDataService.instance.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
           print("\(URL_UPDATE_USERNAME)\(UserDataService.instance.id)")
            if response.result.error == nil {
                print("Ik ben success new Username")
                self.findUserByEmail(completion: { (success) in
                    if success {
                        completion(true)
                        print("succes vol userinfo opgehaald met nieuwe username")
                    }
                })
            } else {
                completion(false)
                print("Ik zit in de debugprint van updateUserName")
                debugPrint(response.result.error as Any)

            }
        }
        
    }
    
    
}
