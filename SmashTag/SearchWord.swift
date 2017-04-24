//
//  SearchWord.swift
//  SmashTag
//
//  Created by Sami Rämö on 22/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SearchWord: NSManagedObject
{
    class func findOrAddSearchWord(_ word: String, tweets: [Twitter.Tweet], in context: NSManagedObjectContext) throws -> SearchWord {
        let request: NSFetchRequest<SearchWord> = SearchWord.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@", word)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "SearchWord.findOrAddSearchWord -- database inconsistency")
                let searchWord = matches[0]
                for tweetInfo in tweets {
                    if (tweetInfo.created as NSDate).timeIntervalSinceNow < searchWord.lastUpdated!.timeIntervalSinceNow {
                        let tweet = try? Tweet.findOrAddTweet(matching: tweetInfo, searchWord: word, context: context)
                        if tweet != nil {
                            searchWord.addToTweets(tweet!)
                        }
                    }
                }
                searchWord.lastUpdated = NSDate()
                return searchWord
            }
        } catch {
            throw error
        }
        
        // create new SearchWord object
        let searchWord = SearchWord(context: context)
        searchWord.keyword = word
        searchWord.lastUpdated = NSDate()
        for tweetInfo in tweets {
            let tweet = try? Tweet.findOrAddTweet(matching: tweetInfo, searchWord: word, context: context)
            if tweet != nil {
                searchWord.addToTweets(tweet!)
            }
        }
        return searchWord
    }

}
