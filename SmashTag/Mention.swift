//
//  Mention.swift
//  SmashTag
//
//  Created by Sami Rämö on 21/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mention: NSManagedObject {
    
    class func findOrAddMention(matching mentionText: String, searchWord: String, tweet: Tweet, context: NSManagedObjectContext) throws -> Mention
    {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@", mentionText)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrAddMention -- database inconsistency")
                let mention = matches[0]
                let tweetRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                tweetRequest.predicate = NSPredicate(format: "text CONTAINS %@ AND text CONTAINS %@", searchWord, mentionText)
                let matchedTweets = try context.count(for: tweetRequest)
                if matchedTweets > 0 {
                    print("searchWord = \(searchWord)")
                    print("matchedTweets = \(matchedTweets)")
                    mention.tweetCount = Int32(matchedTweets)
                    tweet.addToMentions(mention)
                    mention.addToTweets(tweet)
                }
                return mention
            }
        } catch {
            throw error
        }
        // create new mention
        let mention = Mention(context: context)
        mention.keyword = mentionText
        tweet.addToMentions(mention)
        mention.tweetCount = 1
        
        return mention
    }

}
