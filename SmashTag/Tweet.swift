//
//  Tweet.swift
//  SmashTag
//
//  Created by Sami Rämö on 21/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject
{
    class func findOrAddTweet(matching tweetInfo: Twitter.Tweet, searchWord: String, context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", tweetInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrAddTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        // create new Tweet object
        let tweet = Tweet(context: context)
        tweet.identifier = tweetInfo.identifier
        tweet.text = tweetInfo.text
        
        for hashtag in tweetInfo.hashtags {
            do {
                _ = try Mention.findOrAddMention(matching: hashtag.keyword, searchWord: searchWord, tweet: tweet, context: context)
                
            } catch {
                throw error
            }
        }
        for userMention in tweetInfo.userMentions {
            do {
                _ = try Mention.findOrAddMention(matching: userMention.keyword, searchWord: searchWord, tweet: tweet, context: context)
                
            } catch {
                throw error
            }
        }
 
        return tweet
    }

}
