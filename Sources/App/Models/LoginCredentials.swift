//
//  LoginCredentials.swift
//  hls
//
//  Created by Dalton Claybrook on 6/3/17.
//
//

import Foundation
import Vapor

final class LoginCredentials {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension LoginCredentials: JSONInitializable {
    convenience init(json: JSON) throws {
        self.init(
            email: try json.get("email"),
            password: try json.get("password")
        )
    }
}
