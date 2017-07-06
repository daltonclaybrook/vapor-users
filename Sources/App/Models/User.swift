//
//  User.swift
//  vapor-users
//
//  Created by Dalton Claybrook on 2/6/17.
//
//

import AuthProvider
import Vapor
import FluentProvider
import Foundation
import BCrypt

public final class User: Model {
    public let storage = Storage()
    public let email: String
    public let hashedPassword: String
    public let salt: String
    
    public var tokens: Children<User, AuthToken> {
        return children()
    }
    
    public init(email: String, password: String) throws {
        self.email = email
        let salt = try Salt()
        self.salt = salt.bytes.base64Encoded.makeString()
        self.hashedPassword = try Hash.make(message: password, with: salt).base64Encoded.makeString()
    }
    
    public init(row: Row) throws {
        email = try row.get("email")
        hashedPassword = try row.get("password")
        salt = try row.get("salt")
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("email", email)
        try row.set("password", hashedPassword)
        try row.set("salt", salt)
        return row
    }
    
    public func isPasswordCorrect(_ password: String) throws -> Bool {
        let salt = try Salt(bytes: self.salt.bytes.base64Decoded)
        let hash = try Hash.make(message: password, with: salt)
        return hashedPassword == hash.base64Encoded.makeString()
    }
}

extension User: TokenAuthenticatable {
    public typealias TokenType = AuthToken
}

extension User: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self) { (users) in
            users.id()
            users.string("email")
            users.string("password")
            users.string("salt")
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: JSONConvertible {
    public convenience init(json: JSON) throws {
        let email: String = try json.get("email")
        let password: String = try json.get("password")
        
        try Validator.validate(email: email)
        try Validator.validate(password: password)
        
        try self.init(email: email, password: password)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.setId(with: self)
        try json.set("email", email)
        return json
    }
}
