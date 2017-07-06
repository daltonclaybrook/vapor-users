//
//  Abort+Additions.swift
//  vapor-users
//
//  Created by Dalton Claybrook on 2/26/17.
//
//

import Vapor

public extension Abort {
    public static var invalidJSON: Abort {
        return Abort(.badRequest, reason: "The request body did not contain valid JSON or the request did not contain a propert Content-Type header.")
    }

    public static var existingUser: Abort {
        return Abort(.forbidden, reason: "An account already exists with this email address.")
    }

    public static var emailNotFound: Abort {
        return Abort(.notFound, reason: "No account was found for the provided email")
    }

    public static var invalidEmail: Abort {
        return Abort(.badRequest, reason: "The provided email address was invalid")
    }

    public static var wrongPassword: Abort {
        return Abort(.unauthorized, reason: "The provided password was wrong")
    }
}
