//
//  BeamKitUserAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/3/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

private extension String {
    var isDigits: Bool {
      guard !self.isEmpty else { return false }
      return !self.contains { Int(String($0)) == nil }
    }
}

private extension DateFormatter {
    func birthdate(_ dateString: String) -> Date? {
        // API dates look like: "2014-12-10T16:44:31.486000Z"
        //2017-10-05T01:35:33.062098Z
        self.dateFormat = "yyyy-MM-dd"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "en_US_POSIX")
        let date = self.date(from: dateString)
        return date
    }
}

class BeamKitUserAPI {

    
    func registerUser(id: String? = nil,
                      options: JSON?,
                      _ completion: ((String?, BeamError) -> Void)? = nil) {
    
        var body: JSON?
        do {
            body = try registerUserBody(from: options) ?? [:]
        } catch BeamRegisterUserError.invalidBirthdate {
            BKLog.error("Register User: Invalid Birthdate; expected string format YYYY-MM-dd")
            completion?(nil, .invalidUser)
            return
        } catch BeamRegisterUserError.invalidPhone {
            BKLog.error("Register User: Invalid Phone; expected string of digits")
            completion?(nil, .invalidUser)
            return
        } catch BeamRegisterUserError.invalidEmail {
            BKLog.error("Register User: Invalid Email")
            completion?(nil, .invalidUser)
            return
        } catch {
            BKLog.error("Register User Error")
            completion?(nil, .invalidConfiguration)
        }
       // let id = "newalexusertestlikemeeeee"
        if let id = id {
            body?["id"] = id
        }

        let successHandler: (JSON?) -> Void = {  userJSON in
//            guard let userID = userJSON?["user"] as? String else {
//                BKLog.error("Register User: invalid response")
//                completion?(nil, .invalidConfiguration)
//                return
//            }
            
            BKLog.debug("Beam Registered User with id \(String(describing: id))")
            completion?(id, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Register User Error")
            completion?(nil, .networkError)
        }
        
        
        Network.shared.post(urlPath: "users/register",
                            body: body,
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    private func registerUserBody(from options: JSON?) throws -> JSON? {
        // TODO TEST VALIDATION
        guard let options = options else { return nil }
        var body: JSON  = [:]
        
        if let email = options["BeamUserEmailKey"] as? String {
            guard email.contains("@"),
                email.contains(".") else {
                    throw BeamRegisterUserError.invalidEmail
            }
            body["email"] = email
        }
        
        if let phone = options["BeamUserPhoneKey"] as? String {
            guard phone.isDigits else {
                throw BeamRegisterUserError.invalidPhone
            }
            body["phone"] = phone
        }
        
        if let gender = options["BeamUserGenderKey"] as? String {
            body["gender"] = gender
        }
        
        if let name = options["BeamUserFirstNameKey"] as? String {
            body["first_name"] = name
        }
        
        if let last = options["BeamUserLastNameKey"] as? String {
            body["last_name"] = last
        }
        
        if let bday = options["BeamUserBirthDateKey"] as? String {
            guard let date = DateFormatter().birthdate(bday) else {
                throw BeamRegisterUserError.invalidBirthdate
            }
            body["birthdate"] = date.description
        }
        
        return body
    }
}
