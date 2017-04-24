//
//  SmashTableViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 21/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = AppDelegate.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        if justSearched {
            updateDatabase(with: newTweets)
        }
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        container?.performBackgroundTask { [weak self] context in
            //for twitterInfo in tweets {
            //    _ = try? Tweet.findOrAddTweet(matching: twitterInfo, context: context)
            //}
            _ = try? SearchWord.findOrAddSearchWord((self?.searchText)!, tweets: tweets, in: context)
            try? context.save()
            self?.printDatabaseStats()
        }
    }
    
    private func printDatabaseStats() {
        if let context = container?.viewContext {
            context.perform {
                if let tweetCount = try? context.count(for: Tweet.fetchRequest()) {
                    print("\(tweetCount) tweets")
                }
                if let mentionCount = try? context.count(for: Mention.fetchRequest()) {
                    print("\(mentionCount) mentions")
                }
            }
        }
    }

}
