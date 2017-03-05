//
//  Tweet.swift
//  Tweeter
//
//  Created by luc Casimir on 14/02/2017.
//  Copyright © 2017 Owee. All rights reserved.
//

import Foundation

struct Tweet {
    let name : String
    let text : String
    let date : String
}

extension Tweet : CustomStringConvertible {
    var description: String {
        return "\(name):\n\(text)"
    }
}
