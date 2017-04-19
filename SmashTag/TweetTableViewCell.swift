//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Sami Rämö on 16/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!

    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        if let tweetUnwrapped = tweet {
            let attributedText = NSMutableAttributedString(string: tweetUnwrapped.text)
            
            // lets color mentions (urls, hashtags, user mentions)
            if tweetUnwrapped.urls.count > 0 {
                for urls in tweetUnwrapped.urls {
                    let urlColorAttribute = [NSForegroundColorAttributeName: UIColor.blue]
                    attributedText.addAttributes(urlColorAttribute, range: urls.nsrange)
                }
            }
            if tweetUnwrapped.hashtags.count > 0 {
                for hashTag in tweetUnwrapped.hashtags {
                    let hashColorAttribute = [NSForegroundColorAttributeName: UIColor.orange]
                    attributedText.addAttributes(hashColorAttribute, range: hashTag.nsrange)
                }
            }
            if tweetUnwrapped.userMentions.count > 0 {
                for userMention in tweetUnwrapped.userMentions {
                    let userColorAttribute = [NSForegroundColorAttributeName: UIColor.magenta]
                    attributedText.addAttributes(userColorAttribute, range: userMention.nsrange)
                }
            }
            tweetMessageLabel?.attributedText = attributedText
        }
        
        
        
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
