//
//  MentionPopularityTableViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 20/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class MentionPopularityTableViewController: FetchedResultsTableViewController
{
    var fetchedResultsController: NSFetchedResultsController<Mention>?
    
    var container: NSPersistentContainer? = AppDelegate.persistentContainer { didSet { updateUI() } }
    
    var searchWord: String? { didSet { updateUI() } }
    
    override func viewDidLoad() {
        title = "Popular Mentions"
    }
    
    private func updateUI() {
        if searchWord != nil {
            updateDatabase(with: searchWord!)
            tableView.reloadData()
        }
    }
        
    private func updateDatabase(with searchText: String) {
        if let context = container?.viewContext {
            let fetchRequest: NSFetchRequest<Mention> = Mention.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tweetCount", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "%K contains[cd] %@", "tweets.text", searchWord!)
            fetchedResultsController = NSFetchedResultsController<Mention> (
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            try? fetchedResultsController?.performFetch()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularityCell", for: indexPath)
        
        // Configure the cell...
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.keyword
            cell.detailTextLabel?.text = String(mention.tweetCount)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopularMention" {
            if let tweetsVC = (segue.destination as? TweetTableViewController) {
                if let cell = (sender as? UITableViewCell) {
                    tweetsVC.searchText = cell.textLabel?.text
                    tweetsVC.showSearchBar = false
                }
            }
        }
    }
}


