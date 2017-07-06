//
//  JSON+Additions.swift
//  vapor-users
//
//  Created by Dalton Claybrook on 7/5/17.
//
//

import JSON
import Fluent

extension JSON {
    mutating func setId(with entity: Entity) throws {
        let identifier = entity.id
        let value: Any? = identifier?.int ?? identifier?.string
        if let value = value {
            try set("id", value)
        }
    }
}
