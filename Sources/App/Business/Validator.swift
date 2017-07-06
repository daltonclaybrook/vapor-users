//
//  Validator.swift
//  hls-server
//
//  Created by Dalton Claybrook on 6/25/17.
//
//

import Foundation
import Vapor

struct Validator {
    static func validate(email: String) throws {
        let regex = try NSRegularExpression(pattern: "^[^@]+@[^@]+$", options: [.caseInsensitive, .anchorsMatchLines])
        let count = regex.numberOfMatches(in: email, options: .init(rawValue: 0), range: NSRange(location: 0, length: email.characters.count))
        if count == 0 {
            throw Abort.invalidEmail
        }
    }
    
    static func validate(password: String) throws {
        if password.characters.count < 8 {
            throw Abort(.badRequest, reason: "Password must be at least 8 characters long")
        } else if password.rangeOfCharacter(from: .letters) == nil {
            throw Abort(.badRequest, reason: "Password must contain at least one letter")
        } else if password.rangeOfCharacter(from: .decimalDigits) == nil {
            throw Abort(.badRequest, reason: "Password must contain at least one number")
        }
    }
}
