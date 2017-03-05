//
//  APIController.swift
//  Tweeter
//
//  Created by luc Casimir on 14/02/2017.
//  Copyright © 2017 Owee. All rights reserved.
//

import Foundation

protocol APITwitterDelegate : class
{
    func useTweet(Tweet tweet: [Tweet])
    func errorTweet(Error: NSError)
}

class APIController {
    weak var delegate : APITwitterDelegate?
    private var acces_token : String?
    private let token : String
    
    init(Delegate delegate: APITwitterDelegate, Token token:String)
    {
        self.delegate = delegate
        self.token = token
        getAccesToken()
    }
    
    private func getAccesToken()
    {
        let accessTokenUrl = "https://api.twitter.com/oauth2/token"
        let url = URL(string: accessTokenUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error)  in
            if let err = error {
                DispatchQueue.main.async {self.delegate?.errorTweet(Error: err as NSError)}
            }
            else if let d = data {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                            let bearer = dict["access_token"] as? String ?? ""
                            self.acces_token = bearer
                    }
                }
                catch let err as NSError{
                    DispatchQueue.main.async {self.delegate?.errorTweet(Error: err)}
                }
            }
        }
        task.resume()
    }
    
    private func AuthenticateAPIRequest(_ url: URL, bearerToken: String)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + bearerToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {self.delegate?.errorTweet(Error: err as NSError)}
            }
            else if let d = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let tweets = json["statuses"] as? [NSDictionary] {
                            var result = [Tweet]()
                            for tweet in tweets {
                                var currentTweet = (name: "", text: "", date: "")
                                if let name = tweet["user"] as? NSDictionary {
                                    currentTweet.name = name["name"] as? String ?? ""
                                }
                                currentTweet.text = tweet["text"] as? String ?? ""
                                currentTweet.date = tweet["created_at"] as? String ?? ""
                                result.append(Tweet(name: currentTweet.name, text: currentTweet.text, date: currentTweet.date))
                            }
                            DispatchQueue.main.async {self.delegate?.useTweet(Tweet: result)}
                        }
                    }
                }
                catch let err as NSError{
                    DispatchQueue.main.async {self.delegate?.errorTweet(Error: err)}
                }
            }
        }
        task.resume()
    }
    
    func TwitterRequest(Request str:String){
        if let bearer = acces_token {
            let q = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            if let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&count=100&lang=fr&result_type=recent") {
                AuthenticateAPIRequest(url, bearerToken: bearer)
            }
            print("acces token nil")
        }
    }
}
