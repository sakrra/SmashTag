//
//  HistoryTableViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 19/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // MARK: - Table view data source
    var historyData: [String] {
        get {
            let history = HistoryData()
            return history.data ?? []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = historyData[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showHistorySearch" {
            if let tweetVC = (segue.destination as? TweetTableViewController) {
                if let cell = sender as? UITableViewCell {
                    tweetVC.title = cell.textLabel?.text
                    tweetVC.showSearchBar = false
                    tweetVC.searchText = cell.textLabel?.text
                }
            }
        } else if segue.identifier == "showPopulars" {
            if let popularityVC = (segue.destination as? MentionPopularityTableViewController) {
                if let cell = sender as? UITableViewCell {
                    popularityVC.searchWord = cell.textLabel?.text
                }
            }
        }
    }
    

}
