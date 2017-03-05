//
//  APITwitterDelegate.swift
//  Tweeter
//
//  Created by luc Casimir on 14/02/2017.
//  Copyright © 2017 Owee. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class {
    func useTweet(Tweet tweet: [Tweet])
    func errorTweet(Error: NSError)
}
