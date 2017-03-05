//
//  ViewController.swift
//  Tweeter
//
//  Created by luc Casimir on 14/02/2017.
//  Copyright © 2017 Owee. All rights reserved.
//

import UIKit

struct Token {
    let key = "XeXeTAJUPZJr1vjRQS6VJwOhS"
    let secret = "y9ocpgOmyLERYtGUuAnV8yp8cnQHsR6bKeVeMpBxukOM0mBWg5"
    
    func getToken() -> String {
        let bearer = key + ":" + secret
        let token = bearer.data(using: .utf8)?.base64EncodedString()
        return token!
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var apiTwitter : APIController!
    let token = Token()
    var data = [Tweet]()
    
    func setup()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "myCell")
        textField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        apiTwitter = APIController(Delegate: self, Token: token.getToken())
    }

}

extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apiTwitter.TwitterRequest(Request: textField.text!)
        return self.textField.resignFirstResponder()
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? TweetCell
        cell?.setup(WithTweet: data[indexPath.row])
        return cell!
    }
}

extension ViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController : APITwitterDelegate {
    func useTweet(Tweet tweet: [Tweet]) {
        data = tweet
        tableView.reloadData()
    }
    
    func errorTweet(Error: NSError) {
        let alerte = UIAlertController(title: "Error", message: Error.localizedDescription, preferredStyle: .alert)
        alerte.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alerte, animated: true, completion: nil)
    }
}
