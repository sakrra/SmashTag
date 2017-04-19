//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 16/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    
    var showSearchBar = true
    
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            print(tweets)
        }
    }
    
    var searchText: String? {
        didSet {
            searchField?.text = searchText
            searchField?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }

    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: "\(query) -filter retweet", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshData:)), for: .valueChanged)
        //searchText = "#stanford"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField?.isHidden = !showSearchBar
        if !showSearchBar {
           tableView.tableHeaderView = nil
        }
    }
    
    func handleRefresh(refreshData: UIRefreshControl) {
        searchForTweets()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        let tweet: Tweet = tweets[indexPath.section][indexPath.row]
        //cell.textLabel?.text = tweet.text
        //cell.detailTextLabel?.text = tweet.user.name
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchField {
            searchText = searchField.text
        }
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let mentionsViewController = (segue.destination as? MentionsTableViewController) {
            if segue.identifier == "mention" {
                if let tweetCell = (sender as? TweetTableViewCell) {
                    mentionsViewController.tweet = tweetCell.tweet
                }
            }
        }
    }
    

}
