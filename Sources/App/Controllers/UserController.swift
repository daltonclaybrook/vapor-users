//
//  UserController.swift
//  vapor-users
//
//  Created by Dalton Claybrook on 2/6/17.
//
//

import Vapor
import HTTP

public final class UserController: ResourceRepresentable, EmptyInitializable {
    
    public init() {}
    
    public func create(request: Request) throws -> ResponseRepresentable {
        let user = try request.toModel(User.self)
        if try User.makeQuery().filter("email", user.email).first() != nil {
            throw Abort.existingUser
        }
        
        try user.save()
        let token = try AuthToken.generate(withUserID: user.id!)
        try token.save()
        
        return try Response(status: .created, json: try token.makeJSON(with: user))
    }
    
    public func login(request: Request) throws -> ResponseRepresentable {
        let credentials = try request.toModel(LoginCredentials.self)
        guard let user = try User.makeQuery().filter("email", credentials.email).first() else {
            throw Abort.emailNotFound
        }
        guard try user.isPasswordCorrect(credentials.password) else {
            throw Abort.wrongPassword
        }
        let token = try AuthToken.generate(withUserID: user.id!)
        try token.save()
        
        return try token.makeJSON(with: user)
    }
    
    public func makeResource() -> Resource<User> {
        return Resource(store: create)
    }
}
