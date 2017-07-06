//
//  Request+Model.swift
//  vapor-users
//
//  Created by Dalton Claybrook on 6/21/17.
//
//

import HTTP
import JSON

extension Request {
    func toModel<T: JSONInitializable>(_ model: T.Type) throws -> T {
        guard let json = json else { throw Abort.invalidJSON }
        return try T(json: json)
    }
}
