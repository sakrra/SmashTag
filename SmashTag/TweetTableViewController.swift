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
    
    fileprivate var tweets = [Array<Twitter.Tweet>]()
    
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
            return Twitter.Request(search: "\(query) -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            DispatchQueue.global(qos: .userInitiated).async {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshData:)), for: .valueChanged)
        registerForPreviewing(with: self, sourceView: tableView)
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
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchField, textField.text != "" {
            searchText = searchField.text
            var historyData = HistoryData()
            historyData.maxNumberOfItemsStored = 100
            if let text = searchText {
                historyData.add(text)
            }
            print("historyData = \(historyData.data)")
            print("historySize = \(historyData.maxNumberOfItemsStored)")
        }
        return true
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            searchField?.resignFirstResponder()
        }
    }
    
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

extension TweetTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRow(at: location) else { return nil }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MentionsTableViewController.identifier)
        guard let mentionsTableViewController = viewController as? MentionsTableViewController else { return nil }
        mentionsTableViewController.tweet = tweets[indexPath.section][indexPath.row]
        let cellRect = tableView.rectForRow(at: indexPath)
        previewingContext.sourceRect = previewingContext.sourceView.convert(cellRect, from: tableView)
        
        return mentionsTableViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let mentionsTableViewController = viewControllerToCommit as? MentionsTableViewController {
            //chatDetailViewController.isReplyButtonHidden = false
        }
        show(viewControllerToCommit, sender: self)
    }
}
