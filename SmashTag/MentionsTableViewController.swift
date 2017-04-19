//
//  MentionsTableViewController.swift
//  SmashTag
//
//  Created by Sami Rämö on 17/04/2017.
//  Copyright © 2017 Sami Rämö. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        tableView.reloadData()
        title = tweet?.user.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print(tweet)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let tweetUnwrapped = tweet {
            if section == 0 {
                count = tweetUnwrapped.media.count
            } else if section == 1 {
                count = tweetUnwrapped.hashtags.count
            } else if section == 2 {
                count = tweetUnwrapped.userMentions.count
            } else if section == 3 {
                count = tweetUnwrapped.urls.count
            }
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                if let tweetUnwrapped = tweet {
                    imageCell.tweetImageURL = tweetUnwrapped.media[indexPath.row].url
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
            if indexPath.section == 1 {
                cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
            } else if indexPath.section == 2 {
                cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
            } else if indexPath.section == 3 {
                cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let tweetUnwrapped = tweet {
            if section == 0 {
                if tweetUnwrapped.media.count > 0 {
                    return "Images"
                }
            } else if section == 1 {
                if tweetUnwrapped.hashtags.count > 0 {
                    return "Hashtags"
                }
            } else if section == 2 {
                if tweetUnwrapped.userMentions.count > 0 {
                    return "Users mentioned"
                }
            } else if section == 3 {
                if tweetUnwrapped.urls.count > 0 {
                    return "Web links"
                }
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return UITableViewAutomaticDimension
        } else {
            print(tweet!.media[indexPath.row].aspectRatio)
            print(tweet!.media[indexPath.row].description)
            print(view.frame.size.width / CGFloat(tweet?.media[indexPath.row].aspectRatio ?? 0.0))
            return view.frame.size.width / CGFloat(tweet?.media[indexPath.row].aspectRatio ?? 0.0)
        }
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
        if segue.identifier == "showImage" {
            if let cell = sender as? ImageTableViewCell {
                if let imageVC = (segue.destination as? ImageViewController) {
                    imageVC.image = cell.tweetImageView.image
                }
            }
        } else if segue.identifier == "showList" {
            if let tweetVC = segue.destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    tweetVC.showSearchBar = false
                    tweetVC.title = cell.textLabel?.text
                    tweetVC.searchText = cell.textLabel?.text
                }
            }
        }
    }
    

}
