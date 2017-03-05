//
//  TweetCell.swift
//  Tweeter
//
//  Created by luc Casimir on 15/02/2017.
//  Copyright © 2017 Owee. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tuCasseLesCouilles: UILabel!{
        didSet{
            tuCasseLesCouilles.numberOfLines = 0
        }
    }
    
    var setDate : String {
        get {
            return dateLabel.text!
        }
        set{
            let format = DateFormatter()
            format.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
            let newDate = format.date(from: newValue)
            format.dateFormat = "dd/MM/yyyy HH:mm"
            dateLabel?.text = format.string(from: newDate!)
        }
    }
        
    func setup(WithTweet tweet:Tweet)
    {
        nameLabel.text = tweet.name
        setDate = tweet.date
        tuCasseLesCouilles.text = tweet.text
    }
}
