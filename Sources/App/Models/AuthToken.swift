//
//  AuthToken.swift
//  hls
//
//  Created by Dalton Claybrook on 6/3/17.
//
//

import Vapor
import FluentProvider
import Crypto

public final class AuthToken: Model {
    public let token: String
    public let userId: Identifier
    public let storage = Storage()
    
    public var user: Parent<AuthToken, User> {
        return parent(id: userId)
    }
    
    public init(token: String, userId: Identifier) {
        self.token = token
        self.userId = userId
    }
    
    public init(row: Row) throws {
        token = try row.get("token")
        userId = try row.get("userId")
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("token", token)
        try row.set("userId", userId)
        return row
    }
    
    public static func generate(withUserID userId: Identifier) throws -> AuthToken {
        let tokenString = try Hash.random(.sha256).base64Encoded.makeString()
        return AuthToken(token: tokenString, userId: userId)
    }
}

extension AuthToken: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        return try makeJSON(with: nil)
    }
    
    public func makeJSON(with user: User?) throws -> JSON {
        var json = JSON()
        try json.set("token", token)
        if let user = user {
            try json.set("user", try user.makeJSON())
        } else {
            try json.set("userId", userId.int ?? -1)
        }
        return json
    }
}

extension AuthToken: Preparation {
    public static func prepare(_ database: Database) throws {
        try database.create(self) { (tokens) in
            tokens.id()
            tokens.string("token")
            tokens.int("userId")
            tokens.foreignKey(for: User.self)
        }
    }
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
